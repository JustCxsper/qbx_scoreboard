
# qbx_scoreboard

### Features
- **Top Section** (toggleable via config):
  - Players count + Police Online (clickable to show full player list with names, IDs & jobs)
  - Admins On Duty count
- **Illegal Activities / Heists**:
  - Dynamic status icons & colors (green check, spinning hourglass, red lock)
  - Hover preview images for banks/heists (shows location/building image in bottom-left box)
- **Nearby Player IDs** (3D text) appear **only** while scoreboard is open (disappears on close)

- **Configurable**:
  - Show/hide Players & Admins lines (`showPlayers`, `showAdmins`)
  - Enable/disable clickable player list (`enablePlayerList`)
  - Custom hover images per activity (`image = "https://..."` in config)

### Preview
![Scoreboard Preview](https://media.discordapp.net/attachments/1457117971553190055/1470459527576162525/image.png?ex=698b5fa7&is=698a0e27&hm=9cce9001c316a8d6ccfa052be295de6b0cc8a14345e68e5e0c9d626a4b867c9f&=&format=webp&quality=lossless)  

![Hover Image Example](https://cdn.discordapp.com/attachments/1457117971553190055/1470459138265059338/image.png?ex=698b5f4a&is=698a0dca&hm=1fd98482e8d298a82aa8ace4a6f7cbba5135da3cc2411feb7318b9eb66937d06&)

![Player Preview Example](https://media.discordapp.net/attachments/1470469461046722642/1470469462435037547/image.png?ex=698b68e7&is=698a1767&hm=0b809e5dc52ee003a6f3dcd4e5c3c5380e14bd45deaddeb70227e4196c812e6b&=&format=webp&quality=lossless)

### Requirements
- ox_lib
- qbx_core
- lation_ui (Modern UI library)

### Installation
1. Ensure dependencies are started **before** qbx_scoreboard in server.cfg:
   ```
   ensure ox_lib
   ensure qbx_core
   ensure lation_ui
   ensure qbx_scoreboard
   ```

2. Add to your resources folder

3. Configure `config/client.lua`:
   ```lua
   showPlayers      = true       -- Show Players line at top
   showAdmins       = true       -- Show Admins line at top
   enablePlayerList = true       -- Make Players line clickable

   illegalActions = {
       pacific = {
           minimumPolice = 5,
           label = 'Pacific Bank',
           image = 'https://i.imgur.com/your-pacific-image.jpg'  -- optional hover image
       },
       -- add image to others as desired
   }
   ```

4. Restart the resource or server

### Keybinds
- Default: **HOME**

### Credits
- Built on Qbox / qbx_core
- Menu powered by [Lation Scripts Modern UI](https://lationscripts.com/docs/modern-ui)
- Icons from Font Awesome
- Thanks to https://github.com/s4t4n667 for helping out with this and coming up with the idea!

Feel free to contribute, report issues, or suggest improvements!