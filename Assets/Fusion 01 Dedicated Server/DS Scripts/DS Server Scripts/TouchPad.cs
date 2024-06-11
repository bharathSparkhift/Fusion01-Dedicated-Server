using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class TouchPad : MonoBehaviour, IDragHandler, IPointerDownHandler, IPointerUpHandler, IDropHandler
{

    public float DragSpeed = 1.0f;
            
    private bool IsPressed;
    private float Horizontal;
    private float Vertical;

    
    private float previousVerticalValue;
    private float previousHorizontalValue;

    public float swipeThreshold = 50f;

    private Vector2 startDragPosition;

    private RectTransform rectTransform;

    public sbyte charRotateDir { get; private set; }

    public float rotationSpeed = 5f;

    //public Side side;

    public float RotationAmount { get; private set; }

    public float X {
        get
        {
            if (IsPressed)
            {
                
                previousHorizontalValue = Horizontal;
                return Horizontal;
            }
            else
            {
                return 0;
            }
        }
    }
    public float Y
    {
        get
        {
            if (IsPressed)
            {
                previousVerticalValue = Vertical;
                return Vertical;
            }
            else
            {
                return 0;
            }
        }
    }



    #region Monobehaviour callbacks

    private void Awake()
    {
        rectTransform = GetComponent<RectTransform>();
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }
    #endregion

    #region IDragHandler
    public void OnDrag(PointerEventData eventData)
    {
        Horizontal = eventData.delta.x * 0.0061f * DragSpeed;
        Vertical = eventData.delta.y * 0.0061f * DragSpeed;

        // Check the difference between the start and current drag positions
        float dragDelta = eventData.position.x - startDragPosition.x;

        // Check if the drag distance meets the swipe threshold
        if (Mathf.Abs(dragDelta) > swipeThreshold)
        {
            // Determine the direction of the swipe and rotate the player

            if (dragDelta > 0)
                RotationAmount = 1;
            else if (dragDelta < 0)
                RotationAmount = -1;
            else
                RotationAmount = 0;

            // Reset the start position for the next drag
            startDragPosition = eventData.position;

        }
    }

    public void OnPointerDown(PointerEventData eventData)
    {
        IsPressed = true;
        
        
    }

    public void OnPointerUp(PointerEventData eventData)
    {
        IsPressed = false;
        Horizontal = 0;
        Vertical = 0;
    }

    public void OnBeginDrag(PointerEventData eventData)
    {

        startDragPosition = eventData.position;
    }

    public void OnEndDrag(PointerEventData eventData)
    {
        startDragPosition = Vector2.zero;
    }

    public void OnDrop(PointerEventData eventData)
    {
        /*DragUI dragUi = eventData.pointerDrag.GetComponent<DragUI>();

        if (dragUi == null)
            return;

        // Check for the current pivot x position and check the drag UI is of joystick
        if (this.rectTransform.pivot.x == 1 && dragUi.type == DragUI.Type.Joystick) 
        {
            this.rectTransform.anchorMin = new Vector2(0, 0);
            this.rectTransform.anchorMax = new Vector2(0, 1);
            this.rectTransform.pivot = new Vector2(0, 0.5f);
        }
        // Check for the current pivot x position and check the drag UI is of joystick
        else if (this.rectTransform.pivot.x == 0 && dragUi.type == DragUI.Type.Joystick) 
        {
            this.rectTransform.anchorMin = new Vector2(1, 0);
            this.rectTransform.anchorMax = new Vector2(1, 1);
            this.rectTransform.pivot = new Vector2(1, 0.5f);


        }
        Debug.Log($"side Drag UI");*/
    }
    #endregion
}
