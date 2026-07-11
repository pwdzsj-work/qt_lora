#include <QtQml/qqmlprivate.h>
#include <QtCore/qdir.h>
#include <QtCore/qurl.h>

static const unsigned char qt_resource_tree[] = {
0,
0,0,0,0,2,0,0,0,1,0,0,0,1,0,0,0,
8,0,2,0,0,0,23,0,0,0,2,0,0,3,170,0,
0,0,0,0,1,0,0,0,0,0,0,3,82,0,0,0,
0,0,1,0,0,0,0,0,0,2,134,0,0,0,0,0,
1,0,0,0,0,0,0,2,254,0,0,0,0,0,1,0,
0,0,0,0,0,2,212,0,0,0,0,0,1,0,0,0,
0,0,0,0,110,0,0,0,0,0,1,0,0,0,0,0,
0,3,130,0,0,0,0,0,1,0,0,0,0,0,0,1,
30,0,0,0,0,0,1,0,0,0,0,0,0,1,70,0,
0,0,0,0,1,0,0,0,0,0,0,2,48,0,0,0,
0,0,1,0,0,0,0,0,0,0,54,0,0,0,0,0,
1,0,0,0,0,0,0,1,124,0,0,0,0,0,1,0,
0,0,0,0,0,2,172,0,0,0,0,0,1,0,0,0,
0,0,0,0,254,0,0,0,0,0,1,0,0,0,0,0,
0,1,198,0,0,0,0,0,1,0,0,0,0,0,0,0,
218,0,0,0,0,0,1,0,0,0,0,0,0,0,20,0,
0,0,0,0,1,0,0,0,0,0,0,2,100,0,0,0,
0,0,1,0,0,0,0,0,0,1,254,0,0,0,0,0,
1,0,0,0,0,0,0,3,218,0,0,0,0,0,1,0,
0,0,0,0,0,0,168,0,0,0,0,0,1,0,0,0,
0,0,0,3,40,0,0,0,0,0,1,0,0,0,0,0,
0,1,156,0,0,0,0,0,1,0,0,0,0};
static const unsigned char qt_resource_names[] = {
0,
1,0,0,0,47,0,47,0,3,0,0,120,60,0,113,0,
109,0,108,0,14,13,81,121,156,0,68,0,101,0,118,0,
105,0,99,0,101,0,73,0,110,0,102,0,111,0,46,0,
113,0,109,0,108,0,25,9,21,11,124,0,67,0,114,0,
101,0,97,0,116,0,68,0,101,0,118,0,82,0,101,0,
97,0,100,0,68,0,97,0,116,0,97,0,77,0,111,0,
100,0,101,0,108,0,46,0,113,0,109,0,108,0,26,6,
40,82,156,0,67,0,114,0,101,0,97,0,116,0,81,0,
117,0,105,0,99,0,107,0,67,0,111,0,110,0,116,0,
114,0,111,0,108,0,77,0,111,0,100,0,101,0,108,0,
46,0,113,0,109,0,108,0,22,14,173,9,220,0,67,0,
114,0,101,0,97,0,116,0,65,0,114,0,101,0,97,0,
76,0,105,0,115,0,116,0,77,0,111,0,100,0,101,0,
108,0,46,0,113,0,109,0,108,0,15,11,255,63,220,0,
65,0,100,0,100,0,84,0,105,0,109,0,101,0,84,0,
97,0,115,0,107,0,46,0,113,0,109,0,108,0,13,10,
113,11,252,0,77,0,115,0,103,0,68,0,105,0,97,0,
108,0,111,0,103,0,46,0,113,0,109,0,108,0,17,7,
188,175,60,0,65,0,100,0,100,0,65,0,108,0,97,0,
114,0,109,0,86,0,97,0,108,0,117,0,101,0,46,0,
113,0,109,0,108,0,24,7,195,154,28,0,67,0,114,0,
101,0,97,0,116,0,65,0,108,0,97,0,114,0,109,0,
82,0,97,0,110,0,103,0,101,0,77,0,111,0,100,0,
101,0,108,0,46,0,113,0,109,0,108,0,13,9,83,208,
188,0,65,0,100,0,100,0,78,0,101,0,119,0,80,0,
97,0,110,0,46,0,113,0,109,0,108,0,18,15,103,170,
156,0,67,0,112,0,112,0,83,0,105,0,110,0,103,0,
108,0,101,0,116,0,111,0,81,0,109,0,108,0,46,0,
113,0,109,0,108,0,25,10,182,80,156,0,67,0,114,0,
101,0,97,0,116,0,67,0,104,0,97,0,110,0,110,0,
101,0,108,0,80,0,108,0,97,0,110,0,77,0,111,0,
100,0,101,0,108,0,46,0,113,0,109,0,108,0,22,13,
227,134,124,0,67,0,114,0,101,0,97,0,116,0,84,0,
105,0,109,0,101,0,116,0,97,0,115,0,107,0,77,0,
111,0,100,0,101,0,108,0,46,0,113,0,109,0,108,0,
23,8,244,56,92,0,67,0,114,0,101,0,97,0,116,0,
65,0,108,0,97,0,114,0,109,0,76,0,105,0,115,0,
116,0,77,0,111,0,100,0,101,0,108,0,46,0,113,0,
109,0,108,0,14,13,157,210,220,0,65,0,100,0,100,0,
78,0,101,0,119,0,65,0,114,0,101,0,97,0,46,0,
113,0,109,0,108,0,16,3,219,171,156,0,68,0,101,0,
118,0,105,0,99,0,101,0,67,0,111,0,110,0,102,0,
105,0,103,0,46,0,113,0,109,0,108,0,17,10,18,44,
28,0,68,0,97,0,116,0,97,0,84,0,97,0,98,0,
108,0,101,0,86,0,105,0,101,0,119,0,46,0,113,0,
109,0,108,0,18,5,220,227,92,0,65,0,108,0,97,0,
114,0,109,0,84,0,104,0,114,0,101,0,115,0,104,0,
111,0,108,0,100,0,46,0,113,0,109,0,108,0,18,5,
153,41,28,0,67,0,114,0,101,0,97,0,116,0,112,0,
108,0,97,0,110,0,99,0,104,0,98,0,111,0,120,0,
46,0,113,0,109,0,108,0,18,15,3,89,28,0,68,0,
101,0,118,0,72,0,97,0,114,0,100,0,83,0,111,0,
102,0,116,0,86,0,97,0,114,0,46,0,113,0,109,0,
108,0,21,1,137,190,124,0,67,0,114,0,101,0,97,0,
116,0,67,0,72,0,83,0,116,0,97,0,116,0,101,0,
77,0,111,0,100,0,101,0,108,0,46,0,113,0,109,0,
108,0,17,6,111,201,124,0,77,0,97,0,105,0,110,0,
73,0,110,0,116,0,101,0,114,0,102,0,97,0,99,0,
101,0,46,0,113,0,109,0,108,0,21,0,245,201,124,0,
82,0,101,0,99,0,116,0,97,0,110,0,103,0,108,0,
101,0,67,0,104,0,101,0,99,0,107,0,98,0,111,0,
120,0,46,0,113,0,109,0,108,0,9,14,1,242,156,0,
76,0,111,0,103,0,105,0,110,0,46,0,113,0,109,0,
108};
static const unsigned char qt_resource_empty_payout[] = { 0, 0, 0, 0, 0 };
QT_BEGIN_NAMESPACE
extern Q_CORE_EXPORT bool qRegisterResourceData(int, const unsigned char *, const unsigned char *, const unsigned char *);
QT_END_NAMESPACE
namespace QmlCacheGeneratedCode {
namespace _qml_Login_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _qml_RectangleCheckbox_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _qml_MainInterface_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _qml_CreatCHStateModel_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _qml_DevHardSoftVar_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _qml_Creatplanchbox_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _qml_AlarmThreshold_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _qml_DataTableView_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _qml_DeviceConfig_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _qml_AddNewArea_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _qml_CreatAlarmListModel_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _qml_CreatTimetaskModel_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _qml_CreatChannelPlanModel_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _qml_CppSingletoQml_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _qml_AddNewPan_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _qml_CreatAlarmRangeModel_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _qml_AddAlarmValue_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _qml_MsgDialog_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _qml_AddTimeTask_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _qml_CreatAreaListModel_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _qml_CreatQuickControlModel_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _qml_CreatDevReadDataModel_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _qml_DeviceInfo_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}

}
namespace {
struct Registry {
    Registry();
    ~Registry();
    QHash<QString, const QQmlPrivate::CachedQmlUnit*> resourcePathToCachedUnit;
    static const QQmlPrivate::CachedQmlUnit *lookupCachedUnit(const QUrl &url);
};

Q_GLOBAL_STATIC(Registry, unitRegistry)


Registry::Registry() {
        resourcePathToCachedUnit.insert(QStringLiteral("/qml/Login.qml"), &QmlCacheGeneratedCode::_qml_Login_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/qml/RectangleCheckbox.qml"), &QmlCacheGeneratedCode::_qml_RectangleCheckbox_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/qml/MainInterface.qml"), &QmlCacheGeneratedCode::_qml_MainInterface_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/qml/CreatCHStateModel.qml"), &QmlCacheGeneratedCode::_qml_CreatCHStateModel_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/qml/DevHardSoftVar.qml"), &QmlCacheGeneratedCode::_qml_DevHardSoftVar_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/qml/Creatplanchbox.qml"), &QmlCacheGeneratedCode::_qml_Creatplanchbox_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/qml/AlarmThreshold.qml"), &QmlCacheGeneratedCode::_qml_AlarmThreshold_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/qml/DataTableView.qml"), &QmlCacheGeneratedCode::_qml_DataTableView_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/qml/DeviceConfig.qml"), &QmlCacheGeneratedCode::_qml_DeviceConfig_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/qml/AddNewArea.qml"), &QmlCacheGeneratedCode::_qml_AddNewArea_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/qml/CreatAlarmListModel.qml"), &QmlCacheGeneratedCode::_qml_CreatAlarmListModel_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/qml/CreatTimetaskModel.qml"), &QmlCacheGeneratedCode::_qml_CreatTimetaskModel_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/qml/CreatChannelPlanModel.qml"), &QmlCacheGeneratedCode::_qml_CreatChannelPlanModel_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/qml/CppSingletoQml.qml"), &QmlCacheGeneratedCode::_qml_CppSingletoQml_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/qml/AddNewPan.qml"), &QmlCacheGeneratedCode::_qml_AddNewPan_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/qml/CreatAlarmRangeModel.qml"), &QmlCacheGeneratedCode::_qml_CreatAlarmRangeModel_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/qml/AddAlarmValue.qml"), &QmlCacheGeneratedCode::_qml_AddAlarmValue_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/qml/MsgDialog.qml"), &QmlCacheGeneratedCode::_qml_MsgDialog_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/qml/AddTimeTask.qml"), &QmlCacheGeneratedCode::_qml_AddTimeTask_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/qml/CreatAreaListModel.qml"), &QmlCacheGeneratedCode::_qml_CreatAreaListModel_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/qml/CreatQuickControlModel.qml"), &QmlCacheGeneratedCode::_qml_CreatQuickControlModel_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/qml/CreatDevReadDataModel.qml"), &QmlCacheGeneratedCode::_qml_CreatDevReadDataModel_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/qml/DeviceInfo.qml"), &QmlCacheGeneratedCode::_qml_DeviceInfo_qml::unit);
    QQmlPrivate::RegisterQmlUnitCacheHook registration;
    registration.version = 0;
    registration.lookupCachedQmlUnit = &lookupCachedUnit;
    QQmlPrivate::qmlregister(QQmlPrivate::QmlUnitCacheHookRegistration, &registration);
QT_PREPEND_NAMESPACE(qRegisterResourceData)(/*version*/0x01, qt_resource_tree, qt_resource_names, qt_resource_empty_payout);
}

Registry::~Registry() {
    QQmlPrivate::qmlunregister(QQmlPrivate::QmlUnitCacheHookRegistration, quintptr(&lookupCachedUnit));
}

const QQmlPrivate::CachedQmlUnit *Registry::lookupCachedUnit(const QUrl &url) {
    if (url.scheme() != QLatin1String("qrc"))
        return nullptr;
    QString resourcePath = QDir::cleanPath(url.path());
    if (resourcePath.isEmpty())
        return nullptr;
    if (!resourcePath.startsWith(QLatin1Char('/')))
        resourcePath.prepend(QLatin1Char('/'));
    return unitRegistry()->resourcePathToCachedUnit.value(resourcePath, nullptr);
}
}
int QT_MANGLE_NAMESPACE(qInitResources_qml)() {
    ::unitRegistry();
    return 1;
}
Q_CONSTRUCTOR_FUNCTION(QT_MANGLE_NAMESPACE(qInitResources_qml))
int QT_MANGLE_NAMESPACE(qCleanupResources_qml)() {
    return 1;
}
