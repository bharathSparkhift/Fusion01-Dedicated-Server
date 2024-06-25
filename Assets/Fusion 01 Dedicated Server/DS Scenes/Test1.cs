using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Test1 : MonoBehaviour
{
    [SerializeField] GameObject spehere;
    [SerializeField] float force = 15;
    [SerializeField] float disableDelay = 3;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    private void OnCollisionEnter(Collision collision)
    {
        DisableBullet();
    }


    private void OnEnable()
    {
        spehere.gameObject.SetActive(true);
        spehere.GetComponent<Rigidbody>().AddForce(transform.forward, ForceMode.Impulse);
        Invoke(nameof(DisableBullet), disableDelay);
    }

    void DisableBullet()
    {
        
        spehere.gameObject.SetActive(false);
        spehere.transform.position = Vector3.zero;
        CancelInvoke(nameof(DisableBullet));
        Debug.Log($"{nameof(OnCollisionEnter)}");
    }

}
