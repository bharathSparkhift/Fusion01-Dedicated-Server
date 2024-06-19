using LegacyLoot_API;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class ClientIndividualSessionUi : MonoBehaviour
{
    [SerializeField] TMP_Text roomName;
    [SerializeField] TMP_Text portNumber;
    [SerializeField] TMP_Text totalPlayers;
    [SerializeField] TMP_Text region;

    public string RoomName => roomName.text;

    private void Start()
    {
        
    }

    // string roomName, string portNumber, string totalPlayers, string region
    public void UpdateDetails(GameRoom gameRoom)
    {
        this.roomName.text = gameRoom.room_name;
        this.portNumber.text = gameRoom.port_number;
        this.totalPlayers.text = gameRoom.max_players;
        this.region.text = gameRoom.region;
    }

    
}
