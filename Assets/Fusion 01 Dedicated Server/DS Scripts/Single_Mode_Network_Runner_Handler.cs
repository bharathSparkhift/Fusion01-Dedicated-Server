using Fusion;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;



/// <summary>
/// Initialize the Network Runner in the Single Mode.
/// </summary>
public class Single_Mode_Network_Runner_Handler : MonoBehaviour
{
    /// <summary>
    /// Network runner
    /// </summary>
    [SerializeField] NetworkRunner networkRunner;

    // Start is called before the first frame update
    void Start()
    {
        Initialize_Runner_In_Single_Mode();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    async void Initialize_Runner_In_Single_Mode()
    {
        NetworkRunner runner = Instantiate(networkRunner);


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
            Debug.Log($"<color=green>{nameof(Single_Mode_Network_Runner_Handler)} \t {nameof(Initialize_Runner_In_Single_Mode)} \t result {result.Ok}</color>");
        }
        else
        {
            Debug.Log($"<color=red>{nameof(Single_Mode_Network_Runner_Handler)} \t {nameof(Initialize_Runner_In_Single_Mode)} \t result {result.ShutdownReason}</color>");
        }
    }
}
