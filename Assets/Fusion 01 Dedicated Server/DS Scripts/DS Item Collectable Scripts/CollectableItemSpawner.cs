using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class CollectableItemDictionary
{
    public Transform    CollectableItemsParent;
    public Coins        Coins;
}

[Serializable] 
public class Coins
{
    public int TotalGold;
    public Transform Gold;
    public int TotalSilver;
    public Transform Silver;
    public int TotalBronze;
    public Transform Bronze;
}

/// <summary>
/// Spawning the collectable item over the map.
/// </summary>
public class CollectableItemSpawner : MonoBehaviour
{
    #region Serialize private fields
    [SerializeField] private Transform terrain;
    [SerializeField] private CollectableItemDictionary collectableItemDictionary;
    #endregion

    #region Monobehaviour callbacks
    // Start is called before the first frame update
    void Start()
    {
        
    }
    #endregion




    void SpawnCoins()
    {
        /*for(int i = 0; i < collectableItemDictionary.Coins.TotalGold; i++)
        {
            Vector3 randomPos = new Vector3(UnityEngine.Random.Range(0, terrain.localScale.x), 
                                            terrain.localPosition.y + 0.1f, 
                                            terrain.localScale.z);
            Instantiate(collectableItemDictionary.Coins.Gold,position: randomPos, rotation: Quaternion.identity, collectableItemDictionary.CollectableItemsParent); 
        }*/
    }
}
