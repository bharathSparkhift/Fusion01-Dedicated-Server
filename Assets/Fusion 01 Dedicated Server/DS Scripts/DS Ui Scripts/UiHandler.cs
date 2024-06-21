using Fusion;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class UiHandler : NetworkBehaviour
{
    #region Public fields
    public delegate void UiHandlerDelegate(UiHandler uiHandler);
    public static UiHandlerDelegate OnUiHandler;
    #endregion

    #region Serialize private fields
    [SerializeField] Button jumpButton;
    [SerializeField] TMP_Text goldCoinCountText;
    [SerializeField] TMP_Text silverCoinCountText;
    [SerializeField] TMP_Text bronzeCoinCountText;
    //[SerializeField] Button logOutButton;
    #endregion

    #region Monobehaviour callbacks
    private void OnEnable()
    {
        /*if (!Object.HasInputAuthority)
            return;*/
        //logOutButton.onClick.AddListener(LogOutOnButtonClick);
        
    }

    private void OnDisable()
    {
        /*if (!Object.HasInputAuthority)
            return;*/
        //logOutButton.onClick.RemoveAllListeners();

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
    /*void LogOutOnButtonClick()
    {
        if (!Object.HasInputAuthority)
            return;
        OnUiHandler?.Invoke();
        Debug.Log($"{nameof(LogOutOnButtonClick)}");
    }*/
    #endregion

    #region Public methods

    public void UpdateCoinCollectionOnUi(int gold, int silver, int bronze)
    {
        
        goldCoinCountText.text = gold.ToString();
        silverCoinCountText.text = silver.ToString();
        bronzeCoinCountText.text = bronze.ToString();
    }

    public void ScaleDownImageOnButtonClick(Transform transform)
    {
        if (!Object.HasInputAuthority)
            return;
        transform.localScale = Vector3.one * 0.5f;
    }

    public void ScaleUpImageOnButtonClick(Transform transform)
    {
        if (!Object.HasInputAuthority)
            return;
        transform.localScale = Vector3.one;
    }
    #endregion



}
