#include "lora_online_scan.h"

#include "board_config.h"
#include "driver/gpio.h"
#include "driver/uart.h"
#include "esp_log.h"
#include "esp_mac.h"
#include "esp_rom_sys.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include <string.h>

#define LORA_SOF0                 0xA5
#define LORA_SOF1                 0x5A
#define LORA_PROTOCOL_VERSION     0x01
#define LORA_SCAN_REQUEST         0x01
#define LORA_ONLINE_RESPONSE      0x02
#define LORA_SCAN_REQUEST_SIZE    11
#define LORA_ONLINE_PAYLOAD_SIZE  12
#define LORA_ONLINE_FRAME_SIZE    21

#define LORA_DEVICE_RELAY         0x01
#define LORA_CAP_RELAY            (1U << 0)
#define LORA_CAP_ANALOG_INPUT     (1U << 1)
#define LORA_CAP_DIGITAL_INPUT    (1U << 2)
#define LORA_CAP_RTC              (1U << 3)

#ifndef APP_FIRMWARE_MAJOR
#define APP_FIRMWARE_MAJOR        1
#endif
#ifndef APP_FIRMWARE_MINOR
#define APP_FIRMWARE_MINOR        0
#endif

static const char *TAG = "LORA_ONLINE";

static uint16_t crc16(const uint8_t *data, size_t len)
{
    uint16_t crc = 0xFFFF;
    while (len--) {
        crc ^= *data++;
        for (int bit = 0; bit < 8; ++bit)
            crc = (crc & 1U) ? (crc >> 1) ^ 0xA001U : crc >> 1;
    }
    return crc;
}

static uint32_t response_delay_ms(const uint8_t mac[6], uint16_t sequence,
                                  uint8_t slots, uint8_t slot_10ms)
{
    uint32_t hash = 2166136261U ^ sequence;
    for (size_t i = 0; i < 6; ++i) {
        hash ^= mac[i];
        hash *= 16777619U;
    }

    const uint32_t slot_ms = (uint32_t)slot_10ms * 10U;
    const uint32_t slot = hash % slots;
    const uint32_t jitter = slot_ms > 4U ? (hash >> 16) % (slot_ms / 4U) : 0U;
    return slot * slot_ms + jitter;
}

static void send_raw(const uint8_t *data, size_t len)
{
    gpio_set_level(BOARD_RS485_DIR_GPIO, BOARD_RS485_DIR_TX_LEVEL);
    esp_rom_delay_us(50);
    uart_write_bytes(BOARD_RS485_UART, data, len);
    uart_wait_tx_done(BOARD_RS485_UART, pdMS_TO_TICKS(100));
    esp_rom_delay_us(100);
    gpio_set_level(BOARD_RS485_DIR_GPIO, BOARD_RS485_DIR_RX_LEVEL);
}

bool lora_online_scan_process(const uint8_t *rx, size_t len)
{
    if (!rx || len < 2 || rx[0] != LORA_SOF0 || rx[1] != LORA_SOF1)
        return false;

    if (len != LORA_SCAN_REQUEST_SIZE ||
        rx[2] != LORA_PROTOCOL_VERSION ||
        rx[3] != LORA_SCAN_REQUEST ||
        rx[4] != 2) {
        ESP_LOGW(TAG, "Discard malformed scan frame, len=%u", (unsigned)len);
        return true;
    }

    const uint16_t received_crc =
        (uint16_t)rx[len - 2] | ((uint16_t)rx[len - 1] << 8);
    if (received_crc != crc16(rx, len - 2)) {
        ESP_LOGW(TAG, "Discard scan frame with invalid CRC");
        return true;
    }

    const uint8_t slots = rx[7];
    const uint8_t slot_10ms = rx[8];
    if (slots == 0 || slot_10ms == 0)
        return true;

    uint8_t mac[6];
    if (esp_read_mac(mac, ESP_MAC_WIFI_STA) != ESP_OK) {
        ESP_LOGE(TAG, "Unable to read device MAC");
        return true;
    }

    const uint16_t sequence = ((uint16_t)rx[5] << 8) | rx[6];
    uint8_t tx[LORA_ONLINE_FRAME_SIZE] = {
        LORA_SOF0, LORA_SOF1, LORA_PROTOCOL_VERSION, LORA_ONLINE_RESPONSE,
        LORA_ONLINE_PAYLOAD_SIZE, rx[5], rx[6]
    };
    memcpy(&tx[7], mac, sizeof(mac));
    tx[13] = BOARD_MODBUS_SLAVE_ADDR;
    tx[14] = LORA_DEVICE_RELAY;
    tx[15] = BOARD_RELAY_COUNT;
    tx[16] = LORA_CAP_RELAY | LORA_CAP_ANALOG_INPUT |
             LORA_CAP_DIGITAL_INPUT | LORA_CAP_RTC;
    tx[17] = APP_FIRMWARE_MAJOR;
    tx[18] = APP_FIRMWARE_MINOR;
    const uint16_t crc = crc16(tx, LORA_ONLINE_FRAME_SIZE - 2);
    tx[19] = (uint8_t)crc;
    tx[20] = (uint8_t)(crc >> 8);

    const uint32_t delay_ms =
        response_delay_ms(mac, sequence, slots, slot_10ms);
    vTaskDelay(pdMS_TO_TICKS(delay_ms));
    send_raw(tx, sizeof(tx));
    ESP_LOGI(TAG, "Online response sent, address=%u, slot delay=%ums",
             BOARD_MODBUS_SLAVE_ADDR, (unsigned)delay_ms);
    return true;
}
