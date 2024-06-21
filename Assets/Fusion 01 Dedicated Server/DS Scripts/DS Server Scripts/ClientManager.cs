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
using LegacyLoot_API;
using Unity.VisualScripting;

namespace LegacyLoot
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
        /// Main camera
        /// </summary>
        [SerializeField] private Camera mainCamera;
        /// <summary>
        /// Menu Selection Canvas
        /// </summary>
        [SerializeField] private Canvas     menuSelectionCanvas;
        /// <summary>
        /// Capsule Selection Canvas
        /// </summary>
        [SerializeField] private Canvas     capsuleSelectionCanvas;
        /// <summary>
        /// Capsule Player
        /// </summary>
        [SerializeField] private Transform  capsulePlayerSelection;
        /// <summary>
        /// Message out put text
        /// </summary>
        [SerializeField] private TMP_Text messageText;
        #endregion


        #region Private fields

        /// <summary>
        /// Network runner instance.
        /// </summary>
        private NetworkRunner _instanceRunner;
        #endregion

        [field: SerializeField]public Client_API_Handler ClientAPIHandler { get; private set; }
        [SerializeField] ClientIndividualSessionUi[] clientIndividualSessionUis;
        [SerializeField] float clientIndividualSessionUiDisplayDelay = 1f;


        #region Monobehaviour callbacks
        // Start is called before the first frame update
        void Start()
        {
            
        }

        private void OnEnable()
        {
            foreach(var client in clientIndividualSessionUis)
            {
                client.gameObject.SetActive(false);
            }
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
            return runner;
        }
        #endregion

        #region Private fields
        #endregion

        public IEnumerator UpdateUi(int index, GameRoom gameRoom)
        {
            foreach(var client in clientIndividualSessionUis)
            {
                client.gameObject.SetActive(false);
            }
            yield return new WaitForSeconds(clientIndividualSessionUiDisplayDelay); 
            clientIndividualSessionUis[index].UpdateDetails(gameRoom);
            clientIndividualSessionUis[index].gameObject.SetActive(true);
        }

        public void JoinRoom(int index)
        {
            GameRoom selectedGameRoom = ClientAPIHandler.GameRoomsArray[index];
            Debug.Log($"{nameof(JoinRoom)} \t index {index}");
            StartClientRunner(index, selectedGameRoom);
            
        }


        public void StartClientRunner(int index, GameRoom gameRoom)
        {
            _instanceRunner = GetRunner("[client network runner]");
            Debug.Log($"{nameof(StartClientRunner)}");
            StartClient(index, gameRoom);
        }

       

        #region Public methods
        /// <summary>
        /// Start the client on button click.
        /// </summary>
        public async void StartClient(int index, GameRoom gameRoom)
        {

            var result = await StartSimulation(_instanceRunner, GameMode.Client, index, gameRoom);
            
            if (result.Ok == true)
            {
                mainCamera.gameObject.SetActive(false);
                menuSelectionCanvas.gameObject.SetActive(false);
                capsuleSelectionCanvas.gameObject.SetActive(false);
                capsulePlayerSelection.gameObject.SetActive(false);
                messageText.text = $"<color=green>Client Result {result}</color>"; 
                Debug.Log($"{messageText.text}");
            }
            else
            {
                messageText.text = $"<color=red>Failed to join the room</color> \n <color=red>Shut down reason {result.ShutdownReason} \n Error message {result.ErrorMessage}</color>";
                Debug.Log($"{messageText.text}");
                
            }
        }

        /// <summary>
        /// Load server scene on button click.
        /// </summary>
        public void GetIntoServerScene()
        {
            SceneManager.LoadSceneAsync(0);
        }


        

        public Task<StartGameResult> StartSimulation(
            NetworkRunner runner,
            GameMode gameMode,
            int index,
            GameRoom gameRoom
            )
        {
            var appSettings = PhotonAppSettings.Instance.AppSettings.GetCopy();

            // appSettings.FixedRegion = _region.ToString().ToLower(); 

            return runner.StartGame(new StartGameArgs()
            {
                SessionName = clientIndividualSessionUis[index].RoomName,
                GameMode = gameMode,
                SceneManager = runner.gameObject.AddComponent<NetworkSceneManagerDefault>(),
                Scene = SceneManager.GetActiveScene().buildIndex + 1,
                CustomPhotonAppSettings = appSettings,
                DisableClientSessionCreation = true,
                
            });

            
        }

        /// <summary>
        /// Drop down OnValue Changed()
        /// </summary>
        /// <param name="value"></param>
        public void RegionOnValueChanged(int value)
        {

            /*switch (value)
            {
                case 0:
                    _region = Region.asia;
                    break;
                case 1:
                    _region = Region.kr;
                    break;
                case 2:
                    _region = Region.us;
                    break;
            }
            Debug.Log($"{nameof(RegionOnValueChanged)} \t Region name {_region}");*/
        }

        public void OnPlayerJoined(NetworkRunner runner, PlayerRef player)
        {
            
        }

        public void OnPlayerLeft(NetworkRunner runner, PlayerRef player)
        {

            Debug.Log($"{nameof(ClientManager)} \t {nameof(OnPlayerLeft)}");
            // Load the client scene.
            SceneManager.LoadSceneAsync(1);
        }

        public void OnInput(NetworkRunner runner, NetworkInput input)
        {
            
        }

        public void OnInputMissing(NetworkRunner runner, PlayerRef player, NetworkInput input)
        {
            
        }

        public void OnShutdown(NetworkRunner runner, ShutdownReason shutdownReason)
        {
            
        }

        public void OnConnectedToServer(NetworkRunner runner)
        {
            
        }

        public void OnDisconnectedFromServer(NetworkRunner runner)
        {
            
        }

        public void OnConnectRequest(NetworkRunner runner, NetworkRunnerCallbackArgs.ConnectRequest request, byte[] token)
        {
            
        }

        public void OnConnectFailed(NetworkRunner runner, NetAddress remoteAddress, NetConnectFailedReason reason)
        {
            
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
            
        }

        public void OnSceneLoadStart(NetworkRunner runner)
        {
            
        }


        #endregion

    }
}


