const string PluginName = Meta::ExecutingPlugin().Name;
const string MenuIconColor = "\\$fd5";
const string MenuTitle = MenuIconColor + Icons::Magic + "\\$z " + PluginName;

void Main(){
    startnew(LoadFonts);
    // VehicleState::RegisterOnVehicleStateUpdateCallback(OnVehicleUpdate);
    // check permissions and version
    CheckAndSetGameVersionSafe();
    while (!GameVersionSafe) sleep(500);
    HookVehicleVisUpdate.Apply();
    startnew(WatchForRespawnsAndRestartsCoro);
    startnew(DemoCoro);
}

UI::Font@ f_MonoSpace = null;

void LoadFonts() {
	@f_MonoSpace = UI::LoadFont("DroidSansMono.ttf");
}


void RenderMenu() {
    if (!GameVersionSafe) {
        UI::BeginDisabled();
        UI::MenuItem(MenuTitle, Icons::ExclamationTriangle);
        UI::EndDisabled();
        return;
    }
    if (UI::BeginMenu(GenerateAnimatedMenuTitle() + "###skids-m-plgs-mnu")) {
        S_EnableSkidlessGhosts = UI::Checkbox("Enable Skidless Ghosts", S_EnableSkidlessGhosts);
        S_SkidlessGhostsOnlyWhileDriving = UI::Checkbox("Skidless Ghosts only while driving?", S_SkidlessGhostsOnlyWhileDriving);
        S_ClearSkidsOnRestart = UI::Checkbox("Clear Skids on Restart", S_ClearSkidsOnRestart);
        S_ClearSkidsOnRespawn = UI::Checkbox("Clear Skids on Respawn", S_ClearSkidsOnRespawn);
        UI::Separator();
        // UI::AlignTextToFramePadding();
        if (UI::MenuItem("Hotkey: Toggle Skidless Ghosts", GetHotkey_SkidlessGhosts(), false)) {
            EditHotkeys_OpenWindow();
        }
        // UI::AlignTextToFramePadding();
        if (UI::MenuItem("Hotkey: Clear Skids", GetHotkey_ClearSkids(), false)) {
            EditHotkeys_OpenWindow();
        }

        UI::Separator();
        if (UI::Button("Clear Skids Now")) {
            ClearSkids();
        }

        UI::Separator();
        UI::TextDisabled("By XertroV");
        UI::Separator();

        S_EnablePluginFeatures = UI::Checkbox("Plugin Features Enabled", S_EnablePluginFeatures);
        AddSimpleTooltip("Disable plugin features without disabling dependent plugins.");

        UI::Separator();

        bool isApplied = HookVehicleVisUpdate.IsApplied();
        auto newApplied = UI::Checkbox("VehicleState Update Hook Enabled", isApplied);
        AddSimpleTooltip("This is REQUIRED for dependent plugins to work. Disabling this will only disable skidless ghosts and dependent plugins.");
        if (newApplied != isApplied) {
            HookVehicleVisUpdate.Toggle();
            Notify("VehicleState Update Hook " + (newApplied ? "Enabled" : "Disabled"));
        }


        UI::EndMenu();
    }
}

const string SPACES_20 = "                    ";

string GenerateAnimatedMenuTitle() {
    auto baseTitle = MenuTitle + " " + MenuIconColor;
    auto t = Time::Now % 15000;

    // waiting
    if (t < 7000 || t > 10000) return baseTitle + Icons::Magic;
    // blinking
    if (t < 8500) {
        // back and forth motion over 1500 ms
        auto waveState = (t - 7000) / 250 % 2;
        if (waveState == 0) return baseTitle + Icons::Magic;
        else return baseTitle + " " + Icons::Magic;
    }
    if (t < 9750) {
        t = (t - 8500) / 125;
        baseTitle += Icons::Magic + SPACES_20.SubStr(0, t) + "\\$0ff" + Icons::Bolt;
        return baseTitle;
    }
    baseTitle += Icons::Magic + SPACES_20.SubStr(0, 10) + "\\$ff0" + (t < 9875 ? Icons::StarO : Icons::Star);
    return baseTitle;
}





void Render() {
    RenderEditHotkeysWindow();
}


#if TMNEXT
// rcx = CSceneVehicleVis, rdx = CSceneVehicleVisState
void OnVehicleUpdate(uint id, uint64 ptr) {
    // auto id = Dev::ReadUInt32(ptr);
    // trace('ptr: ' + Text::FormatPointer(ptr) + ", id: " + Text::Format("%08x", id));
    if (id & 0xFF000000 != 0x04000000) return;
    SetWheelsFlying(ptr);
}
void SetWheelsFlying(uint64 visStatePtr) {
    // trace('wheels flying: ' + Text::FormatPointer(visStatePtr));
    // setting these to zero makes the camera think the vehicle is flying, 6 and 7 work
    // todo: read them first and only overwrite if ==4
    Dev_WriteChecked(visStatePtr + O_VEHICLESTATE_FL_FLYING, uint(0x7), 4);
    Dev_WriteChecked(visStatePtr + O_VEHICLESTATE_FR_FLYING, uint(0x7), 4);
    Dev_WriteChecked(visStatePtr + O_VEHICLESTATE_RL_FLYING, uint(0x7), 4);
    Dev_WriteChecked(visStatePtr + O_VEHICLESTATE_RR_FLYING, uint(0x7), 4);
}

void Dev_WriteChecked(uint64 addr, uint value, uint expected) {
    if (addr == 0) return;
    if (expected != Dev::ReadUInt32(addr)) return;
    Dev::Write(addr, value);
}

#elif MP4
void OnVehicleUpdate(uint id, uint64 ptr) {
    if (id == 0) return;
    SetWheelsFlying(ptr);
}
#elif TURBO
void OnVehicleUpdate(uint id, uint64 ptr) {
    trace("on vehicle update: " + Text::FormatPointer(ptr) + ", id: " + id);
    // if (id == 0) return;
    SetWheelsFlying(ptr);
}
#endif


#if MP4
void SetWheelsFlying(uint64 visStatePtr) {
    // trace('wheels flying: ' + Text::FormatPointer(visStatePtr));
    // trace('FL :' + Dev::ReadUInt32(visStatePtr + WheelsStartOffset + (0 * WheelStructLength) + 0x14));
    // trace('FR :' + Dev::ReadUInt32(visStatePtr + WheelsStartOffset + (1 * WheelStructLength) + 0x14));
    // trace('RL :' + Dev::ReadUInt32(visStatePtr + WheelsStartOffset + (2 * WheelStructLength) + 0x14));
    // trace('RR :' + Dev::ReadUInt32(visStatePtr + WheelsStartOffset + (3 * WheelStructLength) + 0x14));
    Dev::Write(visStatePtr + WheelsStartOffset + (0 * WheelStructLength) + 0x14, uint(0x0));
    Dev::Write(visStatePtr + WheelsStartOffset + (1 * WheelStructLength) + 0x14, uint(0x0));
    Dev::Write(visStatePtr + WheelsStartOffset + (2 * WheelStructLength) + 0x14, uint(0x0));
    Dev::Write(visStatePtr + WheelsStartOffset + (3 * WheelStructLength) + 0x14, uint(0x0));
}
#elif TURBO
void SetWheelsFlying(uint64 visStatePtr) {
    // trace('wheels flying: ' + Text::FormatPointer(visStatePtr));
    // trace('FL :' + Dev::ReadUInt32(visStatePtr + WheelsStartOffset + (0 * WheelStructLength) + 0x14));
    // trace('FR :' + Dev::ReadUInt32(visStatePtr + WheelsStartOffset + (1 * WheelStructLength) + 0x14));
    // trace('RL :' + Dev::ReadUInt32(visStatePtr + WheelsStartOffset + (2 * WheelStructLength) + 0x14));
    // trace('RR :' + Dev::ReadUInt32(visStatePtr + WheelsStartOffset + (3 * WheelStructLength) + 0x14));
    Dev::Write(visStatePtr + WheelsStartOffset + (0 * WheelStructLength) + 0x14, uint(0x0));
    Dev::Write(visStatePtr + WheelsStartOffset + (1 * WheelStructLength) + 0x14, uint(0x0));
    Dev::Write(visStatePtr + WheelsStartOffset + (2 * WheelStructLength) + 0x14, uint(0x0));
    Dev::Write(visStatePtr + WheelsStartOffset + (3 * WheelStructLength) + 0x14, uint(0x0));
}
#endif

//remove any hooks
void OnDestroyed() { _Unload(); }
void OnDisabled() { _Unload(); }
void _Unload() {
    // VehicleState::DeregisterVehicleStateUpdateCallbacks();
    CheckUnhookAllRegisteredHooks();
    FreeAllAllocated();
}

void RenderEarly() {
    // reset cached is driving each frame
    g_InputMapIsVehicle = UI::CurrentActionMap() == "Vehicle";
    if (!S_EnablePluginFeatures) {
        g_EnableSkidlessGhostsThisFrame = false;
        g_IsPlayerDriving = false;
        return;
    }
    SetIsPlayerDriving();
    g_EnableSkidlessGhostsThisFrame = S_EnablePluginFeatures
        && S_EnableSkidlessGhosts
        && (!S_SkidlessGhostsOnlyWhileDriving || g_IsPlayerDriving);
}

bool g_EnableSkidlessGhostsThisFrame = false;
bool g_IsPlayerDriving = false;
bool g_InputMapIsVehicle = false;

bool SetIsPlayerDriving() {
    g_IsPlayerDriving = g_InputMapIsVehicle
        && DoesViewingEntIdMatchPlayer();
    return g_IsPlayerDriving;
}

bool DoesViewingEntIdMatchPlayer() {
    auto app = GetApp();
    if (app.GameScene is null) return false;
    CSmPlayer@ player = VehicleState::GetViewingPlayer();
    if (player is null) return false;
    if (player.User.Login != app.LocalPlayerInfo.Login) return false;
    auto vehicleId = VehicleState::GetPlayerVehicleID(player);
    auto gameCamera = GetGameCamera(app);
    if (vehicleId != gameCamera.ViewingEntityId) return false;
    // the below takes about 0.3 ms
    auto @state = VehicleState::ViewingPlayerState();
    if (state is null) return false;
    uint entId = Dev::GetOffsetUint32(state, 0);
    if (vehicleId != entId) return false;
    return true;
}

DGameCamera@ GetGameCamera(CGameCtnApp@ app) {
    auto ptr = Dev::GetOffsetUint64(app, GetOffset(app, "GameScene") + 0x10);
    if (ptr <= 0xFFFFFFFFF) return null;
    return DGameCamera(ptr);
}

namespace VehicleState {
    import uint GetPlayerVehicleID(CSmPlayer@ player) from "VehicleState";
}


int playerStartRaceTime = -1;
int playerNbRespawnRequests = -1;

void WatchForRespawnsAndRestartsCoro() {
    auto app = GetApp();
    while (true) {
        while (!S_EnablePluginFeatures || !Playing(app)) yield();
        playerNbRespawnRequests = -1;
        playerStartRaceTime = -1;
        while (S_EnablePluginFeatures && Playing(app)) {
            UpdateWhilePlaying();
            yield();
        }
        yield();
    }
}

bool Playing(CGameCtnApp@ app) {
    if (!g_InputMapIsVehicle) return false;
    if (app.RootMap is null || app.CurrentPlayground is null || app.GameScene is null) return false;
    return true;
}

void UpdateWhilePlaying() {
    CSmPlayer@ player = VehicleState::GetViewingPlayer();
    if (player is null || player.Score is null) return;
    if (playerStartRaceTime == -1) {
        playerStartRaceTime = player.StartTime;
        playerNbRespawnRequests = player.Score.NbRespawnsRequested;
        return;
    }
    if (playerStartRaceTime != player.StartTime) {
        playerStartRaceTime = player.StartTime;
        playerNbRespawnRequests = player.Score.NbRespawnsRequested;
        if (S_ClearSkidsOnRestart) {
            trace('Clear skids on restart');
            ClearSkids();
        }
        return;
    }
    if (playerNbRespawnRequests != player.Score.NbRespawnsRequested) {
        playerNbRespawnRequests = player.Score.NbRespawnsRequested;
        if (S_ClearSkidsOnRespawn) {
            trace('Clear skids on respawn');
            ClearSkids();
        }
    }
}
