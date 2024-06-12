using Fusion;
using Fusion.Sockets;
using Game15Server;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Net.NetworkInformation;
using System.Runtime.CompilerServices;
using UnityEngine;

/// <summary>
/// Client controller, attach this to the Client Network Runner prefab.
/// 
/// Reads the Players Input from the local device and pass it onto the INetworkInput struct to store the values on the server side. 
/// </summary>
public class ClientInputBehaviour : SimulationBehaviour, INetworkRunnerCallbacks
{


    [field: SerializeField] public TouchPad _touchPad { get; private set; }
    [SerializeField] private Camera _camera;

    Vector2 _move;
    bool _jump;
    GameSceneManager _gameSceneManager;




    #region Monobehaviour callbacks
    private void Awake()
    {
        _gameSceneManager = new GameSceneManager();
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    void Update()
    {
        _move = new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
        _jump = Input.GetKeyDown(KeyCode.Space) || Input.GetKeyDown(KeyCode.J);
    }


    #endregion

    #region Networkbehaviour callbacks
    public override void Render()
    {
        if (_touchPad != null)
            return;

        _touchPad = GameObject.FindObjectOfType<TouchPad>();
        _camera = GameObject.FindObjectOfType<Camera>();

    }
    #endregion

    #region INetworkRunner Used Callbacks
    public void OnInput(NetworkRunner runner, NetworkInput input)
    {
        InputStorage _inputStorage = new InputStorage();
        _inputStorage.Move = _move;
        _inputStorage.PlayerButtons.Set(PlayerInputButtons.Jump, _jump);

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
        // _gameSceneManager.AddPlayersToDictionary(player.PlayerId, )
    }

    public void OnPlayerLeft(NetworkRunner runner, PlayerRef player)
    {

        Debug.Log($"{nameof(ClientInputBehaviour)} \t {nameof(OnPlayerLeft)}");
    }

    public void OnInputMissing(NetworkRunner runner, PlayerRef player, NetworkInput input)
    {
        // Debug.Log($"{nameof(OnInputMissing)}");
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
