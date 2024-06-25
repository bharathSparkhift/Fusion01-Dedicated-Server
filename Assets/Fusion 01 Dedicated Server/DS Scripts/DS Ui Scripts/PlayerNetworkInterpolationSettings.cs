using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class PlayerNetworkInterpolationSettings : MonoBehaviour
{
    [SerializeField] TMP_Text minRateValue;
    [SerializeField] Slider minRateSlider;
    [SerializeField] Image minRateImage;

    #region Monobehaviour callbacks
    // Start is called before the first frame update
    void Start()
    {
        
    }
    #endregion

    /// <summary>
    /// MinRate Slider onvalue changed
    /// </summary>
    public void MinRateSliderOnValueChanged()
    {
        minRateValue.text = minRateSlider.value.ToString();
        minRateImage.fillAmount = minRateSlider.value;
    }


}
