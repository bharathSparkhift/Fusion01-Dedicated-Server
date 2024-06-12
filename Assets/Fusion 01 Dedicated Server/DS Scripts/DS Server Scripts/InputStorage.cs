using Fusion;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

enum PlayerInputButtons
{
    Jump
}

public struct InputStorage : INetworkInput
{
    public Vector2 Move;
    public float CameraYrotation;
    public NetworkButtons PlayerButtons;

}
