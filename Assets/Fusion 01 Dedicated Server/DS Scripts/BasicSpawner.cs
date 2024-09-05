using System;
using System.Collections.Generic;
using Fusion;
using Fusion.Sockets;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.SceneManagement;

namespace Fusion102
{
	public class BasicSpawner : MonoBehaviour, INetworkRunnerCallbacks 
	{
		private NetworkRunner _runner;
        private MovementNewInputSystem _movementNewInputSystem;

        [SerializeField] Vector3 spawnPosition = Vector3.zero;

        

        private void Awake()
        {
            _movementNewInputSystem = new MovementNewInputSystem();
        }

        private void OnEnable()
        {
            _movementNewInputSystem?.Enable();
        }

		private void OnDisable() {

            _movementNewInputSystem?.Disable();
    }

        public void Start()
        {
            StartGame(GameMode.Single);
        }

        async void StartGame(GameMode mode)
		{
			// Create the Fusion runner and let it know that we will be providing user input
			_runner = gameObject.AddComponent<NetworkRunner>();
			_runner.ProvideInput = true;
	    
			// Start or join (depends on gamemode) a session with a specific name
			var result = await _runner.StartGame(new StartGameArgs()
			{
				GameMode = mode, 
				SessionName = "TestRoom", 
				Scene = 1, //SceneManager.GetActiveScene().buildIndex,
				SceneManager = gameObject.AddComponent<NetworkSceneManagerDefault>()
			});
			if (result.Ok) {
				Debug.Log($"<color=green>{nameof(StartGame)} result {result.Ok}</color>");
			}
			else
			{
                Debug.Log($"<color=red>{nameof(StartGame)} result {result.ShutdownReason}</color>");
            }
		}

		[SerializeField] private NetworkPrefabRef _playerPrefab; // Character to spawn for a joining player
		private Dictionary<PlayerRef, NetworkObject> _spawnedCharacters = new Dictionary<PlayerRef, NetworkObject>();

		public void OnPlayerJoined(NetworkRunner runner, PlayerRef player)
		{

            NetworkObject networkPlayerObject = runner.Spawn(_playerPrefab, this.spawnPosition, Quaternion.identity, player);
            _spawnedCharacters.Add(player, networkPlayerObject);
			Debug.Log($"<color>{nameof(OnPlayerJoined)}</color>");
        }

		public void OnPlayerLeft(NetworkRunner runner, PlayerRef player)
		{
			if (_spawnedCharacters.TryGetValue(player, out NetworkObject networkObject))
			{
				runner.Despawn(networkObject);
				_spawnedCharacters.Remove(player);
			}
		}

		public void OnInput(NetworkRunner runner, NetworkInput input)
		{


            Server_Input_Struct inputs = new Server_Input_Struct();
            inputs.direction = new Vector3(_movementNewInputSystem.Player.Move.ReadValue<Vector2>().x, 0 , _movementNewInputSystem.Player.Move.ReadValue<Vector2>().y);
			inputs.rotation = TouchPad.instance.RotationAmount;
            input.Set(inputs);
            //Debug.Log($"{nameof(Single_Mode_Network_Runner_Manager)} \t {nameof(OnInput)} \t Inputs Direction {inputs.direction} \t Rotation {inputs.rotation}");
        }
		
		public void OnInputMissing(NetworkRunner runner, PlayerRef player, NetworkInput input) { }
		public void OnShutdown(NetworkRunner runner, ShutdownReason shutdownReason) { }
		public void OnConnectedToServer(NetworkRunner runner) { }
		public void OnDisconnectedFromServer(NetworkRunner runner) { }
		public void OnConnectRequest(NetworkRunner runner, NetworkRunnerCallbackArgs.ConnectRequest request, byte[] token) { }
		public void OnConnectFailed(NetworkRunner runner, NetAddress remoteAddress, NetConnectFailedReason reason) { }
		public void OnUserSimulationMessage(NetworkRunner runner, SimulationMessagePtr message) { }
		public void OnSessionListUpdated(NetworkRunner runner, List<SessionInfo> sessionList) { }
		public void OnCustomAuthenticationResponse(NetworkRunner runner, Dictionary<string, object> data) { }
		public void OnHostMigration(NetworkRunner runner, HostMigrationToken hostMigrationToken) { }
		public void OnReliableDataReceived(NetworkRunner runner, PlayerRef player, ArraySegment<byte> data) { }
		public void OnSceneLoadDone(NetworkRunner runner) { }
		public void OnSceneLoadStart(NetworkRunner runner) { }
	}
}
