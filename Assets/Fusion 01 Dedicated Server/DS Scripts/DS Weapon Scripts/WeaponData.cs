using Fusion;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// Weapon
/// </summary>
[RequireComponent(typeof(BoxCollider))]
public class Weapon : NetworkBehaviour
{
    [Serializable]
    public struct Data
    {
        public string Id;
        public string Name;
        public string Description;
    }

    public Data Data_;

    private void Awake()
    {
    }

    private void Start()
    {
        Data_.Id = Object.Id.ToString();
    }

}
