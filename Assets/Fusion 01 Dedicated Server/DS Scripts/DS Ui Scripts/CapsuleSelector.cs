using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CapsuleSelector : MonoBehaviour
{

    #region Serialize private fields
    [SerializeField] Transform      currentCapsule;
    [SerializeField] Transform[]    capsulePlayer;
    [SerializeField] int           index;
    // [SerializeField] int           currentIndex;
    #endregion

    #region Monobehaviour callbacks
    // Start is called before the first frame update
    void Start()
    {
        index = 0;
        currentCapsule = capsulePlayer[index];
    }
    #endregion

    #region Private methods
    public void UpdateCapsulePlayer(int value)
    {
        
        index += value;
        // currentIndex = index;

        currentCapsule.gameObject.SetActive(false);

        if(index < 0)
            index = 0;

        if (index > capsulePlayer.Length - 1)
            index = (capsulePlayer.Length - 1);

        currentCapsule = capsulePlayer[index];

        currentCapsule.gameObject.SetActive(true);  
    }
    #endregion

}
