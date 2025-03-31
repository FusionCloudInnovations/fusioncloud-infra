# Extract kernel and initrd from Proxmox ISO for PXE Boot (PowerShell - Hardened)

$isoPath = ".\http\proxmox-ve.iso"
$tftpBootDir = ".\tftp\boot"

Write-Host "🔍 Looking for ISO at $isoPath..."

if (!(Test-Path $isoPath)) {
    Write-Error "❌ ISO not found. Please place the Proxmox ISO at $isoPath"
    exit 1
}

# Mount ISO
Write-Host "🗂️ Mounting ISO..."
try {
    $mount = Mount-DiskImage -ImagePath $isoPath -PassThru -ErrorAction Stop
    $volume = $mount | Get-Volume
    $driveLetter = $volume.DriveLetter

    if (-not $driveLetter) {
        throw "Failed to get drive letter after mounting ISO."
    }

    $mountPath = "${driveLetter}:\boot"

    # Validate files exist
    $kernelPath = Join-Path $mountPath "linux26"
    $initrdPath = Join-Path $mountPath "initrd.img"

    if (!(Test-Path $kernelPath) -or !(Test-Path $initrdPath)) {
        throw "Boot files not found in ISO. Check if this is the correct Proxmox ISO."
    }

    # Ensure target dir exists
    if (!(Test-Path $tftpBootDir)) {
        New-Item -ItemType Directory -Path $tftpBootDir | Out-Null
    }

    Write-Host "📦 Copying boot files to $tftpBootDir..."
    Copy-Item $kernelPath "$tftpBootDir\vmlinuz" -Force
    Copy-Item $initrdPath "$tftpBootDir\initrd.gz" -Force

    Write-Host "⏏️ Dismounting ISO..."
    Dismount-DiskImage -ImagePath $isoPath

    Write-Host "🎉 Done. Kernel and initrd extracted."

} catch {
    Write-Error "🚨 Error: $_"
    Write-Host "⚠️ Aborting process."
    if ($mount) {
        Dismount-DiskImage -ImagePath $isoPath -ErrorAction SilentlyContinue
    }
    exit 1
}
