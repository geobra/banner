cmake_minimum_required(VERSION 3.14)

project(banner VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Quick DBus)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick DBus)

set(PROJECT_SOURCES
        source/main.cpp
        source/ScreenSaver.h source/ScreenSaver.cpp
        ui/qml.qrc
)

qt5_add_resources(IMG_RSC_ADDED ui/qml.qrc )

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(banner
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}
    )
# Define target properties for Android with Qt 6 as:
#    set_property(TARGET banner APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
#                 ${CMAKE_CURRENT_SOURCE_DIR}/android)
# For more information, see https://doc.qt.io/qt-6/qt-add-executable.html#target-creation
else()
    if(ANDROID)
        add_library(banner SHARED
            ${PROJECT_SOURCES}
        )
# Define properties for Android with Qt 5 after find_package() calls as:
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
    else()
        add_executable(banner
          ${PROJECT_SOURCES}
          ${IMG_RSC_ADDED}
        )
    endif()
endif()

target_link_libraries(banner
  PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Quick Qt${QT_VERSION_MAJOR}::DBus)

set_target_properties(banner PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

install(TARGETS banner
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

if(QT_VERSION_MAJOR EQUAL 6)
    qt_import_qml_plugins(banner)
    qt_finalize_executable(banner)
endif()

##### install
#install(TARGETS ${PROJECT_NAME} DESTINATION bin)

#if(UNIX)
#  install(FILES res/bitshift.audiobook.desktop DESTINATION share/applications ) # /usr/share?
#  install(FILES res/bitshift.audiobook.svg DESTINATION share/pixmaps ) # /usr/share?
#endif()
