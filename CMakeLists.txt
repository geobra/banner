cmake_minimum_required(VERSION 3.14)

project(banner VERSION 1.1.0 LANGUAGES CXX)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 REQUIRED COMPONENTS Core Quick DBus)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick DBus)

set(PROJECT_SOURCES
        source/main.cpp
        source/Model.cpp source/Model.h
        source/ScreenSaver.h source/ScreenSaver.cpp
        ui/qml.qrc
)

qt_add_executable(banner
    MANUAL_FINALIZATION
    ${PROJECT_SOURCES}
)

target_link_libraries(banner
  PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Quick Qt${QT_VERSION_MAJOR}::DBus)

install(TARGETS banner
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

qt_import_qml_plugins(banner)
qt_finalize_executable(banner)
