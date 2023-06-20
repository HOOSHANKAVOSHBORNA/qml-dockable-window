cmake_minimum_required(VERSION 3.16)

project(XFoo VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appXFoo
    main.cpp
	mainwindow.h mainwindow.cpp
)

qt_add_qml_module(appXFoo
    URI XFoo
    VERSION 1.0
	QML_FILES Main.qml DockableItem.qml DockArea.qml DockSplitView.qml
)

qt_add_resources(appXFoo "images"
	PREFIX "/"
	FILES "images/up_direction.png" "images/drag.png")

qt_add_resources(appXFoo "qmls"
	PREFIX "/"
	FILES "ViewportItem.qml" "DetailsItem.qml" "LightingItem.qml")

set_target_properties(appXFoo PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appXFoo
	PRIVATE Qt6::Quick
)

install(TARGETS appXFoo
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
