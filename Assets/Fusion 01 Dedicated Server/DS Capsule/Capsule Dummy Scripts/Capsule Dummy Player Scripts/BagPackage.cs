using Fusion;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BagPackage : NetworkBehaviour
{
    [Networked] public int GoldCount { get; set; }
    [Networked] public int SilverCount { get; set; }
    [Networked] public int BronzeCount { get; set; }

    [Networked]
    [Capacity(4)]
    [UnitySerializeField]
    private NetworkDictionary<NetworkString<_16>, int> NetDict => default;

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
        if (item != null)
        {
            item.CollectItem();
        }
        else
        {
            Debug.Log("<color=red>CollectableItem script not found</color>");
        }
    }

    private void AddItemsToBag(CollectableItem item)
    {
        switch (item.ItemNameEnum)
        {
            case CollectableItem.ItemName.Gold:
                GoldCount += 1;
                NetDict.Set("Gold", GoldCount);
                break;
            case CollectableItem.ItemName.Silver:
                SilverCount += 1;
                NetDict.Set("Silver", SilverCount);
                break;
            case CollectableItem.ItemName.Bronze:
                BronzeCount += 1;
                NetDict.Set("Bronze", BronzeCount);
                break;
        }

        Debug.Log($"<color=green>Dictionary count {NetDict.Count}</color>");
        foreach (var entry in NetDict)
        {
            Debug.Log($"<color=green>Dictionary key {entry.Key} value {entry.Value}</color>");
        }
    }
}
