using Fusion;
using Fusion.Sockets;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


/// <summary>
/// This will attach to the game object containing the Network Runner.
/// </summary>
public class Single_Mode_Network_Runner_Manager : MonoBehaviour, INetworkRunnerCallbacks
{

    [SerializeField] NetworkRunner runner_;

    [SerializeField] Vector3 spawnPosition = Vector3.zero;
    [SerializeField] Vector2 moveDirection = Vector2.zero;

    [SerializeField] NetworkObject player;
    

    private MovementNewInputSystem _movementNewInputSystem;
   


    private void Awake()
    {
        _movementNewInputSystem = new MovementNewInputSystem();
        Debug.Log($"Move new input system {_movementNewInputSystem}");
    }
    // Start is called before the first frame update
    void Start()
    {
        
        Start_Network_Runner();

        Debug.Log($"{nameof(Single_Mode_Network_Runner_Manager)} \t Initialized");
    }

    void Start_Network_Runner()
    {
        Debug.Log($"{nameof(Start_Network_Runner)}");
        //NetworkRunner runner = Instantiate(runner_);
        runner_.name = gameObject.name;
        runner_.ProvideInput = true;
        runner_.AddCallbacks( this );
        Initialize_Runner_In_Single_Mode(runner_);

    }

    async void Initialize_Runner_In_Single_Mode(NetworkRunner runner)
    {
        //NetworkRunner runner = Instantiate(networkRunner);


        // Set up the NetworkRunner
        var startGameArgs = new StartGameArgs
        {
            GameMode = GameMode.Single, // Set the game mode to Single
            Scene = 1, // SceneManager.GetActiveScene().buildIndex, // Current active scene
            SessionName = "SinglePlayerSession", // Optional: name your session
            PlayerCount = 1 // Single player mode
        };
        var result = await runner.StartGame(startGameArgs);
        if (result.Ok)
        {
            Debug.Log($"<color=green>{nameof(Single_Mode_Network_Runner_Initializer)} \t {nameof(Initialize_Runner_In_Single_Mode)} \t result {result.Ok}</color>");
        }
        else
        {
            Debug.Log($"<color=red>{nameof(Single_Mode_Network_Runner_Initializer)} \t {nameof(Initialize_Runner_In_Single_Mode)} \t result {result.ShutdownReason}</color>");
        }
    }

    private void OnEnable()
    {
        _movementNewInputSystem.Enable();
    }

    private void OnDisable()
    {
        _movementNewInputSystem.Disable();
    }

    // Update is called once per frame
    void Update()
    {
        moveDirection = _movementNewInputSystem.Player.Move.ReadValue<Vector2>();
    }



    public void OnPlayerJoined(NetworkRunner runner, PlayerRef player)
    {
        runner.Spawn(this.player, this.spawnPosition, Quaternion.identity);
        runner.Attach(this.player, inputAuthority: player);
        Debug.Log($"{nameof(Single_Mode_Network_Runner_Manager)} \t {nameof(OnPlayerJoined)}");
    }

    public void OnInput(NetworkRunner runner, NetworkInput input)
    {

        Server_Input_Struct inputs = new Server_Input_Struct();
        inputs.direction = _movementNewInputSystem.Player.Move.ReadValue<Vector2>();
        input.Set(inputs);
        Debug.Log($"{nameof(Single_Mode_Network_Runner_Manager)} \t {nameof(OnInput)} \t Inputs Direction {inputs.direction} \t move direction {moveDirection}");
    }


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
}
