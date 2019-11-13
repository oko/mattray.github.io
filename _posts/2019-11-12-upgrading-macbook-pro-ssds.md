---
title: Upgrading MacBook Pro/Air SSDs
---

Apple laptops are somewhat notoriously resistant to upgrades. The SSDs used by MacBook Air and MacBook Pros shipped between 2013-2017 used a proprietary adapter. Relatively recently (10.13) it became possible to upgrade these systems with an aftermarket adapter and stock NVMe M.2 form factor SSDs. There is an [amazingly thorough thread](https://forums.macrumors.com/threads/upgrading-2013-2014-macbook-pro-ssd-to-m-2-nvme.2034976/) on this, but I figured I'd post my experiences upgrading 2 of my laptops that I've upgraded so far. Go read at least the first page of that thread if you have questions I don't answer, there are 220 pages of feedback so far.

The total cost was under $90 USD each for upgrading to 500 gigagbyte drives.

# Laptop Models

Take the time to figure out exactly which model you have before getting starting. [EveryMac.com](https://everymac.com/) has thorough descriptions of each model, use `About This Mac`->`System Report` to gather up all the details of your system. These are the 2 machines I updated, named for Futurama characters.

| Farnsworth | Bender |
| --- | --- |
| <a href="https://everymac.com/systems/apple/macbook_pro/specs/macbook-pro-core-i5-2.8-13-mid-2014-retina-display-specs.html"><img src="/assets/apple-macbook-pro-13-2013.jpg"/></a> | <a href="https://everymac.com/systems/apple/macbook-air/specs/macbook-air-core-i7-2.2-13-early-2015-specs.html"><img src="/assets/apple-macbook-air-13-2015.jpg"/></a> |
| [MacBookPro11,1 (Mid 2014, Retina 13-inch)](https://everymac.com/systems/apple/macbook_pro/specs/macbook-pro-core-i5-2.8-13-mid-2014-retina-display-specs.html) | [MacBook Air (13-inch, Early 2015)](https://everymac.com/systems/apple/macbook-air/specs/macbook-air-core-i7-2.2-13-early-2015-specs.html) |
| [iFixit SSD Upgrade Guide](https://www.ifixit.com/Guide/MacBook+Pro+13-Inch+Retina+Display+Mid+2014+SSD+Replacement/27849) | [iFixit SSD Upgrade Guide](https://www.ifixit.com/Guide/MacBook+Air+13-Inch+Early+2015+SSD+Upgrade+to+NVMe/119755) |

# Equipment

Make sure you have the right equipment for performing the upgrade. The [iFixit Mac Laptop Repair guides](https://www.ifixit.com/Device/Mac_Laptop) provide excellent step by step instructions for SSD replacements specific to each model. You will need the following equipment:
* P5 Pentalobe and T5 Torx screwdrivers. I bought a [Smart Phone Repair Kit](https://www.bunnings.com.au/trojan-32-piece-smart-phone-repair-kit_p0096177) here in Australia, you may want [something similar from Amazon](https://amzn.to/33OqKte).
* Compressed air for cleaning out dust from the laptop's internals
* Isopryl alcohol for cleaning the aluminum laptop case
* [Heat resistant Kapton/Tesa/Sellotape insulation tape](https://amzn.to/2rzy79q)

## NVMe M.2 SSDs & Adapter

There are a lot of options for which SSD to purchase, the general consensus from the MacRumors thread was that the [Sabrent Rocket](https://amzn.to/2rwWK6D) and [Adata XPG SX8200](https://amzn.to/2KhtG9R) models provide the best price/performance results. If you have a 15" Macbook Pro you may benefit from a faster SSD because of the PCIe 3.0 x4, but the rest of the models are limited by PCIe 2.0 x4 giving them a theoretical limit around 2,000 MB/second (results from the thread rarely get above 1500 MB/s with 13" models. Larger drives (1TB) appear to be a bit faster, I didn't see much need to go beyond 512 gigabytes of storage and wanted to keep it relatively inexpensive. I used the [Adata XPG SX8200 Pro 512GB 3D NAND NVMe Gen3x4 PCIe M.2 2280 Solid State Drive](https://amzn.to/2KhtG9R), but would consider the [Sabrent 512GB Rocket NVMe PCIe M.2 2280 Internal SSD](https://amzn.to/2rwWK6D).

The [Sintech NVMe M.2 adapter](https://amzn.to/32CgDpO) is considered to be the best and you can get them directly from [Amazon](https://amzn.to/32CgDpO).

# Installation Steps

Once you have your parts in hand, here are the steps I followed to upgrade my systems to the latest version of macOS 10.15 'Catalina' with new SSDs.

1. [Create a bootable USB macOS Catalina disk](https://www.macworld.com/article/3442597/how-to-create-a-bootable-macos-catalina-installer-drive.html)
2. Back up the machine with an external Time Machine drive. Make sure you have everything crucial backed up and saved before progressing.
3. Before removing the original hard drive, do a complete upgrade of the macOS operating system to the latest version available (currently 10.15.1) to ensure that any firmware updates available to your machine are applied. This is especially important if you're upgrading from 10.13 or earlier releases.
4. After all the upgrades have been applied, shut down your Mac and follow the relevant [iFixit Mac Laptop Repair guide](https://www.ifixit.com/Device/Mac_Laptop) for removing the SSD from your laptop. Be careful not to strip the P5 and T5 screws.
5. With the case open, take the time to clean it with the compressed air and isopryl alcohol, it's filthy in there.
6. Attach your new SSD to the Sintech adapter and place a small strip of the Kaptop insulation tape across the adapter, [as seen here](/assets/DSC_0128.JPG).
7. Gently insert the new SSD and screw it into the motherboard without overtightening.
8. Close up the laptop case, reversing the steps from the iFixit guide.

## Configuring the Drive and Installing the Operating System

At this point you should be ready to perform a fresh installation of macOS 10.15.

1. Insert your bootable USB stick into the Mac and hold down the Option key while it boots. Select the 'Install macOS Catalina' disk.
2. Choose the Disk Utility, find your new SSD and format it APFS with a GUID Partition Map.
3. Proceed with the macOS installation. You may restore your previous installation from your Time Machine backup if you want, I usually do a fresh install.
4. After completing the install, make sure you have all the latest macOS patches applied.
5. If you have one of the 2013-2014 laptops they will not properly wake from hibernation and you will need to disable it in the terminal with the commands
   ```sudo pmset -a hibernatemode 0 standby 0 autopoweroff 0```

# Results

The upgraded SSDs are noticeably faster and have much more storage than the drives they replaced (128 and 256 gigabytes). The machines have been stable and battery life isn't noticeably different (the batteries were already 50% capacity) even though hibernation is disabled on Farnsworth. Here are the before and after benchmarks from [Blackmagic Disk Speed Test](https://apps.apple.com/au/app/blackmagic-disk-speed-test/id425264550):

## Farnsworth: MacBookPro11,1 (Mid 2014, Retina 13-inch)

| Original Speed | Upgraded Speed |
| --- | --- |
| <a href="/assets/Farnsworth-DiskSpeedTest-original.png"><img src="/assets/Farnsworth-DiskSpeedTest-original.png" alt="Before" width="250" height="252"/></a> | <a href="/assets/Farnsworth-DiskSpeedTest-upgraded.png"><img src="/assets/Farnsworth-DiskSpeedTest-upgraded.png" alt="Upgraded" width="250" height="252"/></a> |

## Bender: MacBook Air (13-inch, Early 2015)

| Original Speed | Upgraded Speed |
| --- | --- |
| <a href="/assets/Bender-DiskSpeedTest-original.png"><img src="/assets/Bender-DiskSpeedTest-original.png" alt="Before" width="250" height="252"/></a> | <a href="/assets/Bender-DiskSpeedTest-upgraded.png"><img src="/assets/Bender-DiskSpeedTest-upgraded.png" alt="Upgraded" width="250" height="252"/></a> |

# Apple SSDs

Other World Computing sells SSD upgrade kits that do not require an M.2 adapter but they are about twice as expensive and performance does not appear to be as good as cheaper drives. They do however, have an external USB 3 case for reusing the original internal Apple SSD. The cases are expensive compared to generic NVMe M.2 SSD USB cases on Amazon, but they will allow you to reuse your Apple SSDs and there are [refurbished models available from OWC](https://eshop.macsales.com/item/OWC/MAU3ENPRPCIU/) for only $60.
