using Fusion;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameSceneManager : SimulationBehaviour
{

    private void Awake()
    {
        
    }

    private void OnEnable()
    {
        UiHandler.OnUiHandler += MenuSceneLoad;
    }

    

    private void OnDisable()
    {
        UiHandler.OnUiHandler -= MenuSceneLoad;
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    private void MenuSceneLoad()
    {
        SceneManager.LoadSceneAsync(1);
    }




}
