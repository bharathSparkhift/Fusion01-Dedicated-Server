using Fusion;
using Fusion.Sockets;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;


namespace Game15Server
{
    /// <summary>
    /// Server game controller for instantiating the player by the server.
    /// </summary>
    public class ServerGameController : SimulationBehaviour, IPlayerJoined, IPlayerLeft, INetworkRunnerCallbacks
    {
        
        [SerializeField] private NetworkObject player;

        private readonly Dictionary<PlayerRef, NetworkObject> _playerMap = new Dictionary<PlayerRef, NetworkObject>();

        public void OnPlayerJoined(NetworkRunner runner, PlayerRef playerRef)
        {
            Quaternion rotation = Quaternion.Euler(0, 180f, 0); 
            NetworkObject Player = runner.Spawn(player, Vector3.zero, rotation, inputAuthority: playerRef);
            runner.gameObject.GetComponent<Rigidbody>().isKinematic = false;
            
            _playerMap[playerRef] = Player;
            Runner.SetPlayerObject(playerRef, Player);
            Debug.Log($"{nameof(OnPlayerJoined)} \t Player {Player} \t PlayerRef {playerRef} ");

        }

        #region Monobehaviour callbacks
        // Start is called before the first frame update
        void Start()
        {

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

            if (_playerMap.Count == 0)
            {
                Log.Info("Last player left, shutdown...");
            }
            Debug.Log($"{nameof(OnPlayerLeft)} ");

        }

        public void PlayerJoined(PlayerRef player)
        {
            Debug.Log($"{nameof(PlayerJoined)}");
        }

        public void PlayerLeft(PlayerRef player)
        {
            Debug.Log($"{nameof(PlayerLeft)}");
        }

        public void OnInput(NetworkRunner runner, NetworkInput input)
        {
            Debug.Log($"{nameof(OnInput)}");
        }

        public void OnInputMissing(NetworkRunner runner, PlayerRef player, NetworkInput input)
        {
            Debug.Log($"{nameof(OnInputMissing)}");
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
}


