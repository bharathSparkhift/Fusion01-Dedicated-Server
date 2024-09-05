using Cinemachine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Cinemachine_Handler : MonoBehaviour
{

    public static Cinemachine_Handler Instance;

    [SerializeField] CinemachineVirtualCamera virtualCamera;
    [SerializeField] TouchPad touchPad;

    private void Awake()
    {
        Instance = this;
        CinemachineCore.GetInputAxis = GetAxis;
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    private float GetAxis(string axisName)
    {
        return axisName switch
        {
            "X" => touchPad.X,
            "Y" => touchPad.Y,
            _ => 0f
        };

    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void Update_Follow(Transform target)
    {
        virtualCamera.Follow = target;
        virtualCamera.LookAt = target;
        Debug.Log($"{nameof(Update_Follow)} \t Target {target}");
    }

}
