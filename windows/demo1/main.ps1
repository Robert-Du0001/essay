if ($args.Count -and $args[0] -eq 'rm' ) { # 删除
    if (-not $args[1]) {
        Write-Host -ForegroundColor Red '请输入要删除的程序名'
        exit
    }

    # 查找创建的设备和驱动器 "$($args[1])"
    $mycomp_path_dir='HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace'
    foreach ($item in Get-ChildItem -Path $mycomp_path_dir -Name) {
        $itemProperty=Get-ItemProperty ($mycomp_path_dir+'\'+$item)
        if ($itemProperty.'(default)' -eq $args[1]) {
            Remove-Item -Path "$mycomp_path_dir\$item" -Recurse
            $clsid=$item
        }
    }

    if ($clsid) {
        Remove-Item -Path "HKLM:\SOFTWARE\Classes\CLSID\$clsid" -Recurse

        '{0}已删除' -f $args[1]
    }else {
        '{0}不存在' -f $args[1]
    }
}else { # 添加
    # 传入必要信息
    $name=Read-Host '请输入要添加的程序名'
    $desc=Read-Host '请输入要添加的程序说明'
    $icon=Read-Host '请输入要添加的程序的图标'
    $exe=Read-Host '请输入要添加的程序的执行文件'

    # 创建clsid字符串
    $uuid=([guid]::NewGuid()).ToString()
    $clsid="{$uuid}"

    # 创建一个clsid并填充相关信息
    $clsid_path_dir='HKLM:\SOFTWARE\Classes\CLSID'
    New-Item -Path $clsid_path_dir -Name $clsid -ItemType 'Directory'
    $clsid_path="$clsid_path_dir\$clsid"
    Set-ItemProperty -Path $clsid_path -Name '(default)' -Value $name
    New-ItemProperty -Path $clsid_path -Name 'System.ItemAuthors' -Value $desc
    New-ItemProperty -Path $clsid_path -Name 'TileInfo' -Value 'prop:System.ItemAuthors'

    New-Item  -Path $clsid_path -Name '\DefaultIcon' -ItemType 'Directory'
    Set-ItemProperty -Path "$clsid_path\DefaultIcon" -Name '(default)' -Value $icon

    # mkdir -p 不能用
    New-Item -Path $clsid_path -Name 'Shell' -ItemType 'Directory'
    New-Item -Path "$clsid_path\Shell" -Name 'Open' -ItemType 'Directory'
    New-Item -Path "$clsid_path\Shell\Open" -Name 'Command' -ItemType 'Directory'
    Set-ItemProperty -Path "$clsid_path\Shell\Open\Command" -Name '(default)' -Value $exe

    # 创建设备和驱动器
    $mycomp_path_dir='HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace'
    New-Item -Path $mycomp_path_dir -Name $clsid -ItemType 'Directory'
    Set-ItemProperty -Path "$mycomp_path_dir\$clsid" -Name '(default)' -Value $name
}
