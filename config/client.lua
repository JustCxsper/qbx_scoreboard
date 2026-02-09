return {
    visibilityDistance = 10,
    openKey = 'HOME',
    toggle = true,

    maxPlayers = GetConvarInt('sv_maxclients', 48),

    idVisibility = 'admin_only',

    showPlayers = true,       -- show/hide the entire "Players"
    showAdmins  = true,       -- show/hide the entire "Admins On Duty"
    enablePlayerList = true,  -- if showPlayers = true, this makes it clickable to show player list

    illegalActions = {
        storerobbery = { minimumPolice = 0,  label = 'Store Robbery',     image = 'https://img.gta5-mods.com/q75/images/7-eleven-stores-prodigyhd/87ca65-GTA5%202016-05-21%2002-06-41-556.png' },
        bankrobbery  = { minimumPolice = 3,  label = 'Bank Robbery',   image = 'https://cdnb.artstation.com/p/assets/images/images/051/910/945/large/noval-fleecca.jpg' },
        jewellery    = { minimumPolice = 2,  label = 'Jewellery',     image = 'https://forum.eclipse-rp.net/uploadsnew/monthly_2024_04/image.png.c18b286080b5886460f35c328aa8eef7.png' },
        pacific      = { minimumPolice = 5,  label = 'Pacific Bank',   image = 'https://i.ytimg.com/vi/hGS7q9tCYks/maxresdefault.jpg' },
        paleto       = { minimumPolice = 4,  label = 'Paleto Bay Bank', image = 'https://static.wikia.nocookie.net/gtawiki/images/a/a7/BlaineCountySavingsBank-GTAV-BlaineCounty.png' }
    }
}