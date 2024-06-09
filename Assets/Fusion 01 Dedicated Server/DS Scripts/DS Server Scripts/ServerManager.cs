using Fusion;
using Fusion.Photon.Realtime;
using Fusion.Sockets;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace Game15Server
{
    /// <summary>
    /// ServerManager
    /// </summary>
    public class ServerManager : MonoBehaviour
    {

        public enum Region
        {
            asia,  
            kr,
            us
        }

        #region Serialize Private Fields
        /// <summary>
        /// Server network runner
        /// </summary>
        [SerializeField] private NetworkRunner _serverRunner;
        /// <summary>
        /// Session name
        /// </summary>
        [SerializeField] private string _sessionName;
        /// <summary>
        /// Port number
        /// </summary>
        [SerializeField] private ushort _port = 27015;
        #endregion

        #region Private Fields
        /// <summary>
        /// Session properties
        /// </summary>
        public Dictionary<string, SessionProperty> SessionProperties { get; private set; } = new Dictionary<string, SessionProperty>();
        #endregion

        #region Public fields

        public Region region;
        #endregion


        #region Monobehaviour callbacks
        // Start is called before the first frame update
        async void Start()
        {

            // SessionProperties.Add();

#if UNITY_SERVER
            var runner = Instantiate(_serverRunner);
            runner.name = "Server";
    

            var appSettings = PhotonAppSettings.Instance.AppSettings.GetCopy();

            appSettings.FixedRegion = region.ToString().ToLower();  // Region.asia.ToString().ToLower();

            StartGameArgs startGameArgs = new StartGameArgs() {
                SessionName = _sessionName,
                GameMode = GameMode.Server,
                SceneManager = runner.gameObject.AddComponent<NetworkSceneManagerDefault>(),
                Scene = 2,
                Address = NetAddress.Any(_port),
                CustomPhotonAppSettings = appSettings,
                PlayerCount = 200,
                DisableClientSessionCreation = false,

                
            };
            var startGame = await runner.StartGame(startGameArgs);
            
            
            if(startGame.Ok == true )
            {
                Debug.Log($"Result {startGame.Ok} :\n Game args {startGameArgs}");
            }
            else
            {
                Debug.LogError($"Result {startGame.Ok} :\n Game args {startGameArgs}");
            }

#else
            SceneManager.LoadScene(1, LoadSceneMode.Single);
#endif

        }
#endregion


    }
}

