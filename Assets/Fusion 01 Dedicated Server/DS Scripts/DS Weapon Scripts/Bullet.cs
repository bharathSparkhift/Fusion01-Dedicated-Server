using Fusion;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.ProBuilder.Shapes;

public class Bullet : NetworkBehaviour
{

    #region Serialize private fields
    
    [SerializeField] private float forwardForce = 10f;
    [SerializeField] private float _lifeTime = 5f;
    [SerializeField] private Vector3 _localPosition = new Vector3(0.001f, 0.133f, 0.916f);
    [field:SerializeField] 
    NetworkBool _tickTimerStarted { get; set; }
    bool _bulletFired;
   
    #endregion


    #region Monobehaviour callbacks
    private void Awake()
    {
        
    }
    // Start is called before the first frame update
    void Start()
    {

    }

    private void OnEnable()
    {

        FireBullet();
    }


    private void OnCollisionEnter(Collision collision)
    {
        DisableBullet();
        Debug.Log($"{nameof(OnCollisionEnter)} \t {collision.gameObject.name}");
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    #endregion

    public void FireBullet()
    {
        // transform.InverseTransformDirection(transform);
        gameObject.SetActive(true);
        Vector3 worlForwardDirection = transform.TransformDirection(Vector3.forward);
        GetComponent<Rigidbody>().AddForce(worlForwardDirection * forwardForce, ForceMode.Impulse);
        Invoke(nameof(DisableBullet), _lifeTime);
    }

    
    void DisableBullet()
    {
        gameObject.SetActive(false);
        transform.localPosition = _localPosition;
        CancelInvoke(nameof(DisableBullet));
        
    }
}
