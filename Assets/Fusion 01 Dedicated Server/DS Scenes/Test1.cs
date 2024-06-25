using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Test1 : MonoBehaviour
{
    [SerializeField] GameObject spehere;
    [SerializeField] float force = 15;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    private void OnCollisionEnter(Collision collision)
    {
        spehere.transform.position = Vector3.zero;
        Debug.Log($"{nameof(OnCollisionEnter)}");
    }

    /*private void OnTriggerEnter(Collider other)
    {
        spehere.transform.position = Vector3.zero;
        Debug.Log($"{nameof(OnTriggerEnter)}");
    }*/

    private void OnEnable()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKeyUp(KeyCode.Space))
        {
            spehere.gameObject.SetActive(true);
            spehere.GetComponent<Rigidbody>().AddForce(transform.forward, ForceMode.Impulse);
  
        }
    }

}
