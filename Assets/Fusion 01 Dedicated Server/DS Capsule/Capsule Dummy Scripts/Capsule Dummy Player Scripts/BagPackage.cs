using UnityEngine;
using Fusion;
using System.Diagnostics;

public class BagPackage : NetworkBehaviour
{

    public struct CollectedDataItem : INetworkStruct
    {

    }

    [Networked] public int GoldCount { get; set; }
    [Networked] public int SilverCount {  get; set; }
    [Networked] public int BronzeCount  { get; set; }

    [Networked]
    [Capacity(4)] 
    [UnitySerializeField] 
    private NetworkDictionary<int, int> NetDict => default;

    #region
    void Start()
    {
        
    }

    private void OnTriggerEnter(UnityEngine.Collider other)
    {
        AddItemsToBag(0);
    }

    #endregion


    public void AddItemsToBag(int value)
    {
        if(value ==  0)
        {
            GoldCount += 1;
            NetDict.Set(0, GoldCount);
        }else if(value == 1)
        {
            SilverCount += 1;
            NetDict.Set(1, SilverCount);
        }
        else if (value == 2)
        {
            BronzeCount += 1;
            NetDict.Set(2, BronzeCount);
        }

        print($"<color=green>Dictionay count {NetDict.Count}</color>");
        foreach(var  item in NetDict)
        {
            print($"<color=green>Dictionay \t key {item.Key} \t value {item.Value}</color>");
        }
    }


}
