using Fusion;
using Fusion.Sockets;
using Game15Server;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Net.NetworkInformation;
using System.Runtime.CompilerServices;
using UnityEngine;


public class ClientInputBehaviour : SimulationBehaviour, INetworkRunnerCallbacks
{


    [field: SerializeField] public TouchPad _touchPad { get; private set; }
    [SerializeField] private Camera         _camera;
    [SerializeField] private double         _ping;

    InputControls       _inputControls;
    Vector2             _move;
    bool                _jump;
    bool                _weaponCollect;
    bool                _fire;
    bool                _logout;
    GameSceneManager    _gameSceneManager;

    NetworkRunner       _currentNetworkRunner;
    PlayerRef           _playerRef;


    /*bool _touchPadDetected;
    TouchPad _touchPad;*/

    #region Monobehaviour callbacks
    private void Awake()
    {
        _inputControls = new InputControls();
        _gameSceneManager = new GameSceneManager();
    }

    void Start()
    {
        
    }

    private void OnEnable()
    {
        _inputControls?.Enable();
    }

    private void OnDisable()
    {
        _inputControls?.Disable();
    }

    void Update()
    {
        
    }

    void LateUpdate()
    {
        _move           = _inputControls.Player.Move.ReadValue<Vector2>();

        _move.Normalize();

        _jump           = _inputControls.Player.Jump.IsPressed();

        _fire           = _inputControls.Player.Fire.IsPressed();

        _weaponCollect  = _inputControls.Player.ItemCollect.IsPressed();

        _logout = _inputControls.Player.Logout.IsPressed();
    }


    #endregion

    #region Networkbehaviour callbacks
    public override void Render()
    {
        if (_touchPad != null)
            return;

        _touchPad = GameObject.FindObjectOfType<TouchPad>();
        _camera = GameObject.FindObjectOfType<Camera>();

        if (_playerRef == null)
            return;
        _ping = Runner.GetPlayerRtt(_playerRef) * 1000;


    }

    public override void FixedUpdateNetwork()
    {
        
    }
    #endregion

    #region INetworkRunner Used Callbacks
    public void OnInput(NetworkRunner runner, NetworkInput input)
    {
        InputStorage _inputStorage = new InputStorage();

        _inputStorage.Move = _move;

        _inputStorage.PlayerButtons.Set(PlayerInputButtons.Jump, _jump);

        _inputStorage.PlayerButtons.Set(PlayerInputButtons.Fire, _fire);

        _inputStorage.PlayerButtons.Set(PlayerInputButtons.Logout, _logout);

        

        // Check for camera
        if (_camera != null)
        {
            // Camera Y rotation angle
            _inputStorage.CameraYrotation = _camera.transform.localEulerAngles.y;
        }
        input.Set(_inputStorage);
    }
    public void OnPlayerJoined(NetworkRunner runner, PlayerRef player)
    {
        _playerRef = player;
        Debug.Log($"{nameof(ClientInputBehaviour)} \t {nameof(OnPlayerJoined)} \t PlayerRef {_playerRef} \t Player {player}");
    }

    public void OnPlayerLeft(NetworkRunner runner, PlayerRef player)
    {
        Debug.Log($"{nameof(ClientInputBehaviour)} \t {nameof(OnPlayerLeft)}");
    }

    public void OnInputMissing(NetworkRunner runner, PlayerRef player, NetworkInput input)
    {

    }

    public void OnShutdown(NetworkRunner runner, ShutdownReason shutdownReason)
    {
        Debug.Log($"{nameof(OnShutdown)}");
    }

    public void OnConnectedToServer(NetworkRunner runner)
    {
        Debug.Log($"{nameof(OnConnectedToServer)}");
    }

    public void OnDisconnectedFromServer(NetworkRunner runner)
    {
        Debug.Log($"{nameof(OnDisconnectedFromServer)}");
    }

    public void OnConnectRequest(NetworkRunner runner, NetworkRunnerCallbackArgs.ConnectRequest request, byte[] token)
    {
        Debug.Log($"{nameof(OnConnectRequest)}");
    }

    public void OnConnectFailed(NetworkRunner runner, NetAddress remoteAddress, NetConnectFailedReason reason)
    {
        Debug.Log($"{nameof(OnConnectFailed)}");
    }

    public void OnUserSimulationMessage(NetworkRunner runner, SimulationMessagePtr message)
    {
        Debug.Log($"{nameof(OnUserSimulationMessage)}");
    }

    public void OnSessionListUpdated(NetworkRunner runner, List<SessionInfo> sessionList)
    {
        Debug.Log($"{nameof(ServerGameController)} Session Available");
        foreach (SessionInfo sessionInfo in sessionList)
        {
            Debug.Log($"Is visible {sessionInfo.IsVisible}");
            Debug.Log($"Is visible {sessionInfo.Name}");
            Debug.Log($"Is visible {sessionInfo.PlayerCount}");
            Debug.Log($"Is visible {sessionInfo.Region}");
            Debug.Log($"Is visible {sessionInfo.MaxPlayers}");
        }
        Debug.Log($"{nameof(OnSessionListUpdated)}");
    }

    public void OnCustomAuthenticationResponse(NetworkRunner runner, Dictionary<string, object> data)
    {
        Debug.Log($"{nameof(OnCustomAuthenticationResponse)}");
    }

    public void OnHostMigration(NetworkRunner runner, HostMigrationToken hostMigrationToken)
    {
        Debug.Log($"{nameof(OnHostMigration)}");
    }

    public void OnReliableDataReceived(NetworkRunner runner, PlayerRef player, ArraySegment<byte> data)
    {
        Debug.Log($"{nameof(OnReliableDataReceived)}");
    }

    public void OnSceneLoadDone(NetworkRunner runner)
    {
        Debug.Log($"{nameof(OnSceneLoadDone)}");
    }

    public void OnSceneLoadStart(NetworkRunner runner)
    {
        Debug.Log($"{nameof(OnSceneLoadStart)}");
    }

    
    #endregion
}
