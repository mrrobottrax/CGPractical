using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    public float moveSpeed = 5f; //player movementspeed in inspecter
    public float mouseSensitivity = 100f; //mouse sens in inspecter

    private float xRotation = 0f; //x represnets vertical rotation
    private Transform playerCamera; //refers to the camera
    private bool isCursorLocked = true; //the state of the cursor

    private void Start()
    {
        // Lock the cursor to the center of the screen initially
        playerCamera = Camera.main.transform;
        LockCursor();
        xRotation = 0f;
        playerCamera.localRotation = Quaternion.Euler(xRotation, 0f, 0f);
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.C))
        {
            ToggleCursor(); //unlocks the cursor
        }

        // Only allow movement and camera rotation when the cursor is locked
        if (isCursorLocked)
        {
            MovePlayer();
            RotateCamera();
        }
    }

    private void MovePlayer()
    {
        float horizontal = Input.GetAxis("Horizontal");
        float vertical = Input.GetAxis("Vertical");

        Vector3 direction = transform.right * horizontal + transform.forward * vertical;
        transform.position += direction * moveSpeed * Time.deltaTime;
        //gets the inputs and calculates/updates the position
    }

    private void RotateCamera()
    {
        float mouseX = Input.GetAxis("Mouse X") * mouseSensitivity * Time.deltaTime;
        float mouseY = Input.GetAxis("Mouse Y") * mouseSensitivity * Time.deltaTime;

        xRotation -= mouseY;
        xRotation = Mathf.Clamp(xRotation, -90f, 90f);

        playerCamera.localRotation = Quaternion.Euler(xRotation, 0f, 0f);
        transform.Rotate(Vector3.up * mouseX);
        //gets the inputs and calculates/updates the camera
    }

    private void ToggleCursor()
    {
        if (isCursorLocked)
        {
            UnlockCursor(); //view cursor
        }
        else
        {
            LockCursor(); //hide cursor
        }
    }

    private void LockCursor()
    {
        Cursor.lockState = CursorLockMode.Locked; //locks cursor
        Cursor.visible = false; //hides cursor
        isCursorLocked = true; //updates state of cursor
    }

    private void UnlockCursor()
    {
        Cursor.lockState = CursorLockMode.None; //unlocks cursor
        Cursor.visible = true; //shows cursor
        isCursorLocked = false; //updates state of cursor
    }
}