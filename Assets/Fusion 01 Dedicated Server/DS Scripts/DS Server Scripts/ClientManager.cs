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
    public class ClientManager : MonoBehaviour
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
        /// Canvas
        /// </summary>
        [SerializeField] private Canvas canvas;
        /// <summary>
        /// Session name.
        /// </summary>
        [SerializeField] private TMP_InputField sessionName;
        /// <summary>
        /// Region drop down menu.
        /// </summary>
        [SerializeField] private TMP_Dropdown clientRegionDropDownMenu;
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
            return runner;
        }
        #endregion

        #region Private fields
        Region _region;
        #endregion


        public void StartClientRunner()
        {
            _instanceRunner = GetRunner("Client Network Runner");
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

            var result = await StartSimulation(_instanceRunner, GameMode.Client, sessionName.text.Trim());
            
            if (result.Ok == true)
            {
                mainCamera.gameObject.SetActive(false);
                canvas.gameObject.SetActive(false);
                Debug.Log($"Client Result {result.ToString()}");
            }
            else
            {
                Debug.LogError($"Client Result {result.ToString()}");
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
            string sessionName)
        {
            Debug.Log($"------------------------{nameof(ClientManager)} : {gameMode}------------------------");

            var appSettings = PhotonAppSettings.Instance.AppSettings.GetCopy();
            appSettings.FixedRegion = _region.ToString().ToLower(); 

            return runner.StartGame(new StartGameArgs()
            {
                SessionName = sessionName,
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

            switch (value)
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

            Debug.Log($"{nameof(RegionOnValueChanged)} \t Region name {_region}");
        }
        #endregion

    }
}


