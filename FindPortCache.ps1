[CmdletBinding(SupportsShouldProcess=$True)]
param ([string][Parameter(Mandatory)] $name, [switch] $delete, [switch] $interactive, [string] $searchInside, [switch] $doNotSkipBinaries)

$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

$PSStyle.Progress.View = 'Classic'

function MaybeRemove($file) {
    if ($interactive) {
        $decision = $host.UI.PromptForChoice("Delete archive?", "Do you want to remove $file?", $choices, 1)
        if ($decision -eq 0) {
            #Write-Host("would like to delete $file")
            Remove-Item $file
        }
    }
    if ($delete) {
        #Write-Host("would like to delete $file")
        Remove-Item $file
    }
}

Add-Type -assembly "system.io.compression.filesystem"
$files = Get-ChildItem -Path "$env:LOCALAPPDATA\vcpkg\archives" -Filter *.zip -Recurse
$numfiles = $files.Count
$currfile = 0

$bins = @("exe", "dll", "pdb", "lib")

foreach ($file in $files){
    $OuterLoopProgressParameters = @{
        Activity         = 'Searching Archives'
        Status           = 'Progress'
        PercentComplete  = ($currfile++ / $numfiles) * 100
        CurrentOperation = "$file"
    }
    Write-Progress @OuterLoopProgressParameters
    $zipfile = [io.compression.zipfile]::OpenRead($file)
    $names = $zipfile.Entries.Name | Select-String -Pattern $name

    if ($searchInside) {
        $numentries = $zipfile.Entries.Count
        $currentry = 0
        foreach ($entry in $zipfile.Entries) {
            $InnerLoopProgressParameters = @{
                ID               = 1
                Activity         = 'Searching Contents'
                Status           = 'Progress'
                PercentComplete  = ($currentry++ / $numentries) * 100
                CurrentOperation = "$entry"
            }
            Write-Progress @InnerLoopProgressParameters
            if (-not $doNotSkipBinaries -and $bins.Contains((Split-Path -Path $entry -Leaf).Split(".")[-1].ToLower())) {
                #Write-Host("skipping $entry")
                Continue
            }
            $stream = $entry.Open()
            $reader = New-Object IO.StreamReader($stream)
            $text = $reader.ReadToEnd()
            $text = $text -split '\r?\n'
            $reader.Close()
            $stream.Close()
            $found = $text | Select-String -Pattern $searchInside
            if($found) {
                Write-Host("$entry in $file")
                foreach ($m in $found) {
                    Write-Host("found inside: $m")
                }
                MaybeRemove($file)
            }
        }
    }
    $zipfile.Dispose()
    if ($names -and -not $searchInside) {
        Write-Host("$file matches: $names")
        MaybeRemove($file)
    }
}