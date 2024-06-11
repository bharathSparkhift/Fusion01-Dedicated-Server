using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UiHandler : MonoBehaviour
{

    public delegate void UiHandlerDelegate();
    public static UiHandlerDelegate OnUiHandler;


    [SerializeField] Button logOutButton;

    private void OnEnable()
    {
        logOutButton.onClick.AddListener(LogOutOnButtonClick);
    }

    private void OnDisable()
    {
        logOutButton.onClick.RemoveAllListeners();
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    /// <summary>
    /// Logout button on click
    /// </summary>
    void LogOutOnButtonClick()
    {
        OnUiHandler?.Invoke();
        Debug.Log($"{nameof(LogOutOnButtonClick)}");
    }



}
