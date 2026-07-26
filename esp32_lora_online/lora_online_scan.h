#pragma once

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

/*
 * Handles one complete LoRa online-scan frame received from the RS485/LoRa
 * transparent link. Returns true when the frame belongs to this protocol.
 */
bool lora_online_scan_process(const uint8_t *rx, size_t len);
