using Fusion;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameSceneManager : SimulationBehaviour
{
    [Networked, Capacity(11), UnitySerializeField]
    public NetworkDictionary<NetworkString<_32>, Transform> ConnectedPlayersDictionary => default;

    [Networked]
    [Capacity(11)] 
    [UnitySerializeField] 
    private NetworkLinkedList<NetworkString<_32>> NetPlayersNetworkIdList { get; } // = MakeInitializer(new NetworkString<_32>[] { "#0", "#1", "#2", "#3" });

    private void Awake()
    {


    }

    // Start is called before the first frame update
    void Start()
    {
        
    }



    public void AddPlayerNetworkObjectIdToArrayList(string objectId)
    {
        // Debug.Log($"NetPlayersNetworkIdList Count {NetPlayersNetworkIdList.Count}");
        // NetPlayersNetworkIdList.Add(objectId);
        foreach(var id in  NetPlayersNetworkIdList)
        {
            Debug.Log($"id {id}");
        }
    }


    public void AddPlayersToDictionary(string objectId, Transform transform)
    {
        ConnectedPlayersDictionary.Add(objectId, transform);
        foreach(var  player in ConnectedPlayersDictionary)
        {
            Debug.Log($"Player ID {player.Key}");   
        }
        Debug.Log($"{nameof(AddPlayersToDictionary)} {ConnectedPlayersDictionary.Count}");
    }

    public void RemovePlayersFromDictionary(string objectId)
    {
        if(ConnectedPlayersDictionary.Count != 0)
        {
            ConnectedPlayersDictionary.Remove(objectId);
            ConnectedPlayersDictionary.TryGet(objectId, out Transform transform);
            Destroy(transform.gameObject);
            Debug.Log($"{nameof(RemovePlayersFromDictionary)} {ConnectedPlayersDictionary.Count}");
        }
        
    }

   
}
