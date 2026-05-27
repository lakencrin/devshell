install(
    FILES
        devenv.ps1
    DESTINATION
        .
    CONFIGURATIONS
        Release
)

install(
    FILES
        utils/main-utils.ps1
        utils/devenv-add-to-path.ps1
    DESTINATION
        utils
    CONFIGURATIONS
        Release
)