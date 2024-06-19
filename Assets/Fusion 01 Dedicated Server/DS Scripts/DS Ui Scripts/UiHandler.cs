using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class UiHandler : MonoBehaviour
{
    #region Public fields
    public delegate void UiHandlerDelegate();
    public static UiHandlerDelegate OnUiHandler;
    #endregion

    #region Serialize private fields
    [SerializeField] Button jumpButton;
    [SerializeField] Button logOutButton;
    #endregion

    #region Monobehaviour callbacks
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

  
    #endregion


    #region Private methods
    /// <summary>
    /// Logout button on click
    /// </summary>
    void LogOutOnButtonClick()
    {
        OnUiHandler?.Invoke();
        Debug.Log($"{nameof(LogOutOnButtonClick)}");
    }
    #endregion

    #region Public methods
    public void ScaleDownImageOnButtonClick(Transform transform)
    {
        transform.localScale = Vector3.one * 0.5f;
    }

    public void ScaleUpImageOnButtonClick(Transform transform)
    {
        transform.localScale = Vector3.one;
    }
    #endregion



}
