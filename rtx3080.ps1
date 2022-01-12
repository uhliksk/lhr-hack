c: ; cd "\Program Files\NVIDIA Corporation\NVSMI"

$gpu=0;
$last=0;
$hcycle=2.98;
$limit=$hcycle;
$cycle=8;

$lpw=128; $lhr= 22; $lperc= 27; $lfr=210;
$mpw=157; $mhr= 45; $mperc= 57; $mfr=480;
$hpw=228; $hhr= 96; $hperc=100; $hfr=1230;

$duration=1800; $calibration=18; $key=0; .\nvidia-smi.exe -i $gpu -lmc 10000; while ($key -ne 27) { $mcycle=$cycle-$hcycle; if ($calibration -ne 0) { Write-Host -ForegroundColor yellow "$(Get-Date -Format u) Unlocking ...";  .\nvidia-smi.exe -i $gpu -lgc $lfr | Out-Null; sleep -m ($calibration*1000); }; $util=100; $time=0; for ($i=$calibration; ($i -le $duration) -and ([int]$util -ne 66) -and ($key -ne 27); $i=$i+$hcycle+$mcycle) { Write-Host -ForegroundColor yellow "$(Get-Date -Format u) Runtime: $([math]::Floor($time/60)):$(($time%60).ToString('00')), Last: $([math]::Floor($last/60)):$(($last%60).ToString('00'))"; .\nvidia-smi.exe -i $gpu -lgc $hfr | Out-Null; sleep -m ($hcycle*1000); .\nvidia-smi.exe -i $gpu -lgc $mfr | Out-Null; sleep -m ($mcycle*1000); $util=((.\nvidia-smi.exe -i $gpu -q -d UTILIZATION | Select -index 23)[44..46] -join ''); $load=($calibration*$lperc+($duration-$calibration)*(($hcycle*$hperc+$mcycle*$mperc)/($hcycle+$mcycle)))/$duration; $power=($calibration*$lpw+($duration-$calibration)*(($hcycle*$hpw+$mcycle*$mpw)/($hcycle+$mcycle)))/$duration; $speed=($calibration*$lhr+($duration-$calibration)*(($hcycle*$hhr+$mcycle*$mhr)/($hcycle+$mcycle)))/$duration; Write-Host -ForegroundColor green "Utilization: $util %, Boost: $([math]::Round($hcycle,2)) s, Cycle: $([math]::Round($cycle,1)) s, Load: $([math]::Round($load,1)) %, Power: $([math]::Round($power,1)) W, Speed: $([math]::Round($speed,1)) MH/s, Efficiency: $([math]::Round(1000*$speed/$power,2)) kH/J"; $time+=$hcycle+$mcycle; $key=0; while ([Console]::KeyAvailable) { $key=($host.ui.RawUI.ReadKey("NoEcho,IncludeKeyUp")).VirtualKeyCode; if ($key -eq 107) { $hcycle=$hcycle+0.02; $mcycle=$cycle-$hcycle; Write-Host -ForegroundColor red "Boost increased to: $([math]::Round($hcycle,2)) s" }; if ($key -eq 109) { $hcycle=$hcycle-0.02; $mcycle=$cycle-$hcycle; Write-Host -ForegroundColor red "Boost decreased to: $([math]::Round($hcycle,2)) s" }; if ($key -eq 38) { $cycle=$cycle+0.2; $mcycle=$cycle-$hcycle; Write-Host -ForegroundColor red "Cycle increased to: $([math]::Round($cycle,1)) s" }; if ($key -eq 40) { $cycle=$cycle-0.2; $mcycle=$cycle-$hcycle; Write-Host -ForegroundColor red "Cycle decreased to: $([math]::Round($cycle,1)) s" }; if ($key -eq 39) { $limit=$limit+0.02; Write-Host -ForegroundColor red "Boost limit increased to: $([math]::Round($limit,2)) s" }; if ($key -eq 37) { $limit=$limit-0.02; Write-Host -ForegroundColor red "Boost limit decreased to: $([math]::Round($limit,2)) s" }; }; }; if ($calibration -gt 0) { $last=0; }; $calibration=18; if ($time -lt ($duration/3)) { $hcycle=$hcycle-0.02 }; if ($time -gt (2*$duration/3)) { $hcycle=$hcycle+0.02; $calibration=0; if ($hcycle -gt $limit) { $hcycle=$limit; Write-Host -ForegroundColor red "Boost limit reached: $([math]::Round($hcycle,2)) s"; } else { Write-Host -ForegroundColor red "Boost raised to: $([math]::Round($hcycle,2)) s" }; }; $last+=$time; }; .\nvidia-smi.exe -i $gpu -rgc; .\nvidia-smi.exe -i $gpu -rmc
