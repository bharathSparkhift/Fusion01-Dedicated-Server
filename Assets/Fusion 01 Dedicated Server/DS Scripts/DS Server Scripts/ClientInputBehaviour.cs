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

    // [SerializeField] private Camera _camera;


    private Vector2 moveDirection;
    private Vector2 joyStick;
    
    private float cameraYrotation;

    private bool jumpButton;
    private bool upArrowButton;
    private bool downArrowButton;



    /// <summary>
    /// INetwork input to store the inputs from the user on the server side.
    /// </summary>
    // PlayerInputStruct _cachedInput = new PlayerInputStruct();

    #region Monobehaviour callbacks
    private void Awake()
    {

    }

    private void OnEnable()
    {

        
    }

    private void OnDisable()
    {

        
    }

    

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        


    }

    #endregion

    #region Networkbehaviour callbacks
    public override void Render()
    {


    }
    #endregion

    #region Private methods

    #endregion

    #region INetworkRunner Used Callbacks


    public void OnInput(NetworkRunner runner, NetworkInput input)
    {

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

    public void OnPlayerJoined(NetworkRunner runner, PlayerRef player)
    {

    }

    public void OnPlayerLeft(NetworkRunner runner, PlayerRef player)
    {

    }
    #endregion
}
