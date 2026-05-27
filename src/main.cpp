#include <iostream>
#include <string>

#include <Windows.h>

int main(int argc, char* argv[])
{
    if (HWND hWnd = GetConsoleWindow())
        ShowWindow(hWnd, SW_HIDE);

    PROCESS_INFORMATION pi{};
    STARTUPINFOW si{};
    si.cb = sizeof(si);

    // wchar_t* programName = L"powershell.exe";
    wchar_t* command = L"powershell.exe -NoProfile -ExecutionPolicy Bypass -NoExit -File \"D:\\dev\\devenv\\devenv.ps1\" -ConfigName vcpkg";
    int commandBufferSize = lstrlenW(command);
    std::wstring commandBuffer;
    commandBuffer.assign(command);

    BOOL ok = CreateProcessW(
        NULL,
        commandBuffer.data(),
        NULL,
        NULL,
        FALSE,
        0,
        NULL,
        NULL,
        &si,
        &pi
    );

    if (ok != TRUE)
    {
        std::wcout << L"Unexpected error during powershell startup: " << GetLastError() << std::endl;
        return 1;
    }

    WaitForSingleObject(pi.hProcess, INFINITE);
    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);

    return 0;
};