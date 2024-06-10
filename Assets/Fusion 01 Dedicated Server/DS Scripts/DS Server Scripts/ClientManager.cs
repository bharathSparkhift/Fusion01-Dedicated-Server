using Fusion;
using Fusion.Photon.Realtime;
using Fusion.Sockets;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using TMPro;
using static Game15Server.ServerManager;

namespace Game15Server
{
    /// <summary>
    /// Client manager script to instantiate the clients on the network.
    /// </summary>
    public class ClientManager : MonoBehaviour, INetworkRunnerCallbacks
    {

        #region Serialize private fields
        /// <summary>
        /// Client network runner prefab.
        /// </summary>
        [SerializeField] private NetworkRunner _clientNetworkRunner;
        /// <summary>
        /// Session name.
        /// </summary>
        [SerializeField] private TMP_InputField sessionName;
        #endregion


        #region Private fields

        /// <summary>
        /// Network runner instance.
        /// </summary>
        private NetworkRunner _instanceRunner;
        #endregion

        #region Monobehaviour callbacks
        // Start is called before the first frame update
        void Start()
        {
            StartClientRunner();
        }

        private void OnEnable()
        {

        }

        private void OnDisable()
        {

        }

        #endregion

        #region Private fields
        /// <summary>
        /// Instantiating the client runner prefab.
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        private NetworkRunner GetRunner(string name)
        {

            var runner = Instantiate(_clientNetworkRunner);
            runner.name = name;
            runner.ProvideInput = true;
            runner.AddCallbacks(this);
            Debug.Log($"----------{runner.name}----------");
            return runner;
        }
        #endregion

        #region Public fields
        public Region _Region;
        #endregion


        public void StartClientRunner()
        {
            _instanceRunner = GetRunner("Client");
            Debug.Log($"{nameof(StartClientRunner)}");
        }

        public void NewSessionDetails()
        {
            Debug.Log($"{nameof(NewSessionDetails)} Session Available");
            List<SessionInfo> sessionList = new List<SessionInfo>();
            foreach (SessionInfo sessionInfo in sessionList)
            {
                Debug.Log($"Is visible {sessionInfo.IsVisible}");
                Debug.Log($"Is visible {sessionInfo.Name}");
                Debug.Log($"Is visible {sessionInfo.PlayerCount}");
                Debug.Log($"Is visible {sessionInfo.Region}");
                Debug.Log($"Is visible {sessionInfo.MaxPlayers}");
            }
            
        }

        #region Public methods
        /// <summary>
        /// Start the client on button click.
        /// </summary>
        public async void StartClient()
        {
            // _instanceRunner = GetRunner("Client");

            var result = await StartSimulation(_instanceRunner, GameMode.Client, sessionName.text.Trim());
            Debug.Log($"--------------- {nameof(ClientManager)}  Result {result.Ok} ------------------");
            if (result.Ok == false)
            {
                Debug.LogWarning(result.ShutdownReason);
            }
            else
            {
                Debug.Log("--------------- Done ------------------");
            }
        }

        public Task<StartGameResult> StartSimulation(
            NetworkRunner runner,
            GameMode gameMode,
            string sessionName
          )
        {
            Debug.Log($"------------------------{nameof(ClientManager)} : {gameMode}------------------------");

            var appSettings = PhotonAppSettings.Instance.AppSettings.GetCopy();

            appSettings.FixedRegion = _Region.ToString().ToLower(); 
            


            return runner.StartGame(new StartGameArgs()
            {
                SessionName = sessionName,
                GameMode = gameMode,
                SceneManager = runner.gameObject.AddComponent<NetworkSceneManagerDefault>(),
                Scene = SceneManager.GetActiveScene().buildIndex,
                CustomPhotonAppSettings = appSettings,
                DisableClientSessionCreation = true,
                
            });

            
        }
        #endregion

        #region INetwork Runner callbacks
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

        public void OnInput(NetworkRunner runner, NetworkInput input)
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
            
            foreach (SessionInfo sessionInfo in sessionList)
            {
                Debug.Log($"Is visible {sessionInfo.IsVisible}");
                Debug.Log($"Is visible {sessionInfo.Name}");
                Debug.Log($"Is visible {sessionInfo.PlayerCount}");
                Debug.Log($"Is visible {sessionInfo.Region}");
                Debug.Log($"Is visible {sessionInfo.MaxPlayers}");
            }
            Debug.Log($"{nameof(OnSessionListUpdated)} Session Available");
        }

        public void OnShutdown(NetworkRunner runner, ShutdownReason shutdownReason)
        {
            
        }

        public void OnUserSimulationMessage(NetworkRunner runner, SimulationMessagePtr message)
        {
            
        }
        #endregion
    }
}


