# LHR hack in PowerShell

**Instructions:**

- Reset GPU clocks, power and voltage to default
- Start Excavator v1.7.3b/NHQM 0.5.2 or older
- Start the script
- Follow the instructions to set correct GPU Core Clock and Memory Clock

**Note:**

Tested on RTX 3080 and RTX 3080 Ti only. Not compatible with newest Excavator/NHQM because of their own implementation of LHR hack which can't be disabled.

**Performance:**

Powershell version

| GPU  | Memory OC | Hashrate | Power | Efficiency |
| --- | --- | --- | --- | --- |
| RTX 3080  | +1050 MHz | 71.40 MH/s | 199 W | 358.79 kH/J |
| RTX 3080 Ti  | +1400 MHz | 87.25 MH/s  | 243 W | 359.05 kH/J |

Standalone version

| GPU  | Memory OC | Hashrate | Power | Efficiency |
| --- | --- | --- | --- | --- |
| RTX 3080  | +1050 MHz | 73.83 MH/s | 200 W | 369.15 kH/J |
| RTX 3080 Ti  | +1400 MHz | 90.83 MH/s  | 246 W | 369.22 kH/J |
