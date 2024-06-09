using Fusion;
using Fusion.Sockets;
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

    [SerializeField] private Camera _camera;
    bool _zipLineEnabled;

    private Vector2 moveDirection;
    private Vector2 joyStick;
    
    private float cameraYrotation;

    private bool jumpButton;
    private bool upArrowButton;
    private bool downArrowButton;
    private bool zipLineButton;
    private bool helicopterEnterButton;
    private bool helicopterExitButton;
    private bool _punchButton;



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
    #endregion

    #region INetworkRunner Unused Callbacks
    public void OnConnectedToServer(NetworkRunner runner)
    {

    }

    public void OnConnectFailed(NetworkRunner runner, NetAddress remoteAddress, NetConnectFailedReason reason)
    {

    }

    public void OnConnectRequest(NetworkRunner runner, NetworkRunnerCallbackArgs.ConnectRequest request, byte[] token)
    {

    }

    public void OnCustomAuthenticationResponse(NetworkRunner runner, Dictionary<string, object> data)
    {

    }

    public void OnDisconnectedFromServer(NetworkRunner runner)
    {

    }

    public void OnHostMigration(NetworkRunner runner, HostMigrationToken hostMigrationToken)
    {

    }



    public void OnInputMissing(NetworkRunner runner, PlayerRef player, NetworkInput input)
    {

    }

    public void OnPlayerJoined(NetworkRunner runner, PlayerRef player)
    {

    }

    public void OnPlayerLeft(NetworkRunner runner, PlayerRef player)
    {

    }

    public void OnReliableDataReceived(NetworkRunner runner, PlayerRef player, ArraySegment<byte> data)
    {

    }

    public void OnSceneLoadDone(NetworkRunner runner)
    {

    }

    public void OnSceneLoadStart(NetworkRunner runner)
    {

    }

    public void OnSessionListUpdated(NetworkRunner runner, List<SessionInfo> sessionList)
    {

    }

    public void OnShutdown(NetworkRunner runner, ShutdownReason shutdownReason)
    {

    }

    public void OnUserSimulationMessage(NetworkRunner runner, SimulationMessagePtr message)
    {

    }
    #endregion
}
