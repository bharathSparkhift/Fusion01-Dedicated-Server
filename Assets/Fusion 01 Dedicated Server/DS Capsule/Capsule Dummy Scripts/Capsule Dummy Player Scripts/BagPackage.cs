using Fusion;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BagPackage : NetworkBehaviour
{
    [Networked]
    [Capacity(4)]
    [UnitySerializeField]
    private NetworkDictionary<NetworkString<_16>, int> NetDict => default;

    /// <summary>
    /// Item collected dictionary
    /// </summary>
    private Dictionary<string, int> CollectableItemDictionary = new Dictionary<string, int>();


    private int GoldCount; 
    private int SilverCount;
    private int BronzeCount;

    private void OnEnable()
    {
        CollectableItem.CollectableItemHandler += AddItemsToBag;
       
    }

    

    private void OnDisable()
    {
        CollectableItem.CollectableItemHandler -= AddItemsToBag;

    }

    private void OnTriggerEnter(UnityEngine.Collider other)
    {
        var item = other.GetComponent<CollectableItem>();
        item.CollectItem();
       

    }

    private void AddItemsToBag(CollectableItem item)
    {
        switch (item.ItemNameEnum)
        {
            case CollectableItem.ItemName.Gold:
                GoldCount += 1;
                CollectableItemDictionary["Gold"] = GoldCount;
                break;
            case CollectableItem.ItemName.Silver:
                SilverCount += 1;
                CollectableItemDictionary["Silver"] = SilverCount;
                break;
            case CollectableItem.ItemName.Bronze:
                BronzeCount += 1;
                CollectableItemDictionary["Bronze"] = BronzeCount;
                break;
        }

        Debug.Log($"<color=green>Dictionary count {NetDict.Count}</color>");
        foreach (var collectableItem in CollectableItemDictionary)
        {
            Debug.Log($"<color=green>Dictionary key {collectableItem.Key} value {collectableItem.Value}</color>");
        }
    }

    /*private void DisableCollectableItem(CollectableItem collectableItem)
    {
        
    }*/


}
