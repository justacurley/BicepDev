# This wraps bicep.exe so we can capture standard output and error streams.
# Start-Process will only redirect to a file.
# Github's windows-latest build image (at time of writing) does not allow
#  powershell to call bicep inline and redirect output
function bicepProcWrap ($BicepDeploymentFile) {
    $bicep = New-Object System.Diagnostics.ProcessStartInfo
    $bicep.FileName = "bicep.exe"
    $bicep.RedirectStandardError = $true
    $bicep.RedirectStandardOutput = $true
    $bicep.UseShellExecute = $false
    $bicep.Arguments = "build $BicepDeploymentFile"
    $bicepProc = New-Object System.Diagnostics.Process
    $bicepProc.StartInfo = $bicep
    $bicepProc.Start() | Out-Null
    $bicepProc.WaitForExit()
    $stdout = $bicepProc.StandardOutput.ReadToEnd()
    # stderr will return warnings and errors
    $stderr = $bicepProc.StandardError.ReadToEnd()
    if ($stderr) {
        $stderr.Split("`n")
    }
}
