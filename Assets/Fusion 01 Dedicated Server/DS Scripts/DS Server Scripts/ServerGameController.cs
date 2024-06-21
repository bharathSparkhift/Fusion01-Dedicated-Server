using Fusion;
using Fusion.Sockets;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.TextCore.Text;



namespace Game15Server
{
    /// <summary>
    /// Server game controller for instantiating the player by the server.
    /// </summary>
    public class ServerGameController : SimulationBehaviour, INetworkRunnerCallbacks
    {
        
        [SerializeField] private NetworkObject player;

        NetworkRunner _networkRunner;

        private readonly Dictionary<PlayerRef, NetworkObject> _playerMap = new Dictionary<PlayerRef, NetworkObject>();

        private void Awake()
        {
            _networkRunner = new NetworkRunner();
        }

        public void OnPlayerJoined(NetworkRunner runner, PlayerRef player)
        {
            var character = runner.Spawn(this.player, new Vector3(18,2,17), inputAuthority: player);
            _playerMap[player] = character;
            Debug.Log($"Spawn for Player: {player}");

        }

        #region Monobehaviour callbacks
        void Start()
        {

        }

        #endregion


        #region Public methods
        public async void ShutDownServer()
        {
            await Runner.Shutdown();
            Debug.Log($"<color=red>{nameof(ServerGameController)} \t {nameof(ShutDownServer)}</color>");
            return;
        }
        #endregion

        #region INetwork Runner callbacks
        public void OnPlayerLeft(NetworkRunner runner, PlayerRef player)
        {
            if (_playerMap.TryGetValue(player, out var character))
            {
                // Despawn Player
                runner.Despawn(character);

                // Remove player from mapping
                _playerMap.Remove(player);

                
                Log.Info($"Despawn for Player: {player}");
            }
            Debug.Log($"<color=green>Active players {Runner.ActivePlayers}</color>");
        }

     

        public void OnInput(NetworkRunner runner, NetworkInput input)
        {

        }

        public void OnInputMissing(NetworkRunner runner, PlayerRef player, NetworkInput input)
        {

        }

        public void OnShutdown(NetworkRunner runner, ShutdownReason shutdownReason)
        {
            SceneManager.UnloadSceneAsync(2);
            Debug.Log($"<color=red>{nameof(ServerGameController)} \t {nameof(OnShutdown)}</color>");

        }

        public void OnConnectedToServer(NetworkRunner runner)
        {
            Debug.Log($"<color=green>{nameof(ServerGameController)} \t {nameof(OnConnectedToServer)}</color>");
        }

        public void OnDisconnectedFromServer(NetworkRunner runner)
        {
            Debug.Log($"<color=red>{nameof(ServerGameController)} \t {nameof(OnDisconnectedFromServer)}</color>");
            
        }

        public void OnConnectRequest(NetworkRunner runner, NetworkRunnerCallbackArgs.ConnectRequest request, byte[] token)
        {
       
        }

        public void OnConnectFailed(NetworkRunner runner, NetAddress remoteAddress, NetConnectFailedReason reason)
        {
            Debug.Log($"<color=red>{nameof(ServerGameController)} \t {nameof(OnConnectFailed)}</color>");
        }

        public void OnUserSimulationMessage(NetworkRunner runner, SimulationMessagePtr message)
        {

        }

        public void OnSessionListUpdated(NetworkRunner runner, List<SessionInfo> sessionList)
        {
           
        }

        public void OnCustomAuthenticationResponse(NetworkRunner runner, Dictionary<string, object> data)
        {

        }

        public void OnHostMigration(NetworkRunner runner, HostMigrationToken hostMigrationToken)
        {

        }

        public void OnReliableDataReceived(NetworkRunner runner, PlayerRef player, ArraySegment<byte> data)
        {

        }

        public void OnSceneLoadDone(NetworkRunner runner)
        {
            Debug.Log($"<color=yellow>{nameof(ServerGameController)} \t {nameof(OnSceneLoadDone)}</color>");
        }

        public void OnSceneLoadStart(NetworkRunner runner)
        {
            Debug.Log($"<color=yellow>{nameof(ServerGameController)} \t {nameof(OnSceneLoadStart)}</color>");
        }


        #endregion
    }
}


