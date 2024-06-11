using Cinemachine;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public delegate void CameraDelegate();

public class FirstPersonCamera : MonoBehaviour
{
    public enum CameraEnum
    {
        Tpp,
        ZipLine,
        Helicopter
    }

    public event CameraDelegate CameraDelegate;


    #region Serialize private fields
    [SerializeField] TouchPad _touchPad;
    [SerializeField] Transform _mainCamera;
    [SerializeField] float _rotationSpeed;
    #endregion


    #region Private fields

    #endregion

    #region Public properties
    public Transform MainCamera { get { return _mainCamera; } }
    public Transform Target;
    public CinemachineVirtualCamera _currentVirtualCamera;
    public CinemachineVirtualCamera[] _virtualCamera;
    public CameraEnum cameraEnum;

    public float MouseSensitivity = 10f;
    public Vector3 _offset;
    public Vector2 VerticalClamp = new Vector2(-70f, 70f);
    public Vector2 HorizontalClamp = new Vector2(-70f, 70f);
    #endregion

    #region Private fields
    private float verticalRotation;
    private float horizontalRotation;
    public static FirstPersonCamera Instance;
    #endregion

    private float GetAxis(string axisName)
    {
        return axisName switch
        {
            "X" => _touchPad.X,
            "Y" => _touchPad.Y,
            _ => 0f
        };

    }


    #region Monobehaviour callbacks
    void Awake()
    {
        Instance = this;
        CinemachineCore.GetInputAxis = GetAxis;
    }

  

    void Update()
    {
        if (Target == null)
            return;
    }
    #endregion

    public static void SwitchCamera(FirstPersonCamera camera)
    {
        camera._currentVirtualCamera.gameObject.SetActive(false);
        camera._currentVirtualCamera = camera._virtualCamera[(byte)camera.cameraEnum];
        camera._currentVirtualCamera.gameObject.SetActive(true);
    }
                                                                   
}
