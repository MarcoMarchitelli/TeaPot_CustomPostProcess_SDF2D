using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

public class Input_Test : MonoBehaviour
{
    Camera cam;
    PostProcessVolume volume;
    SDF2D_TEST TestSettings;

    Vector2 mouseClickPos;
    int currentPointIndex;
    public static Vector4[] registeredPoints;
    public static int arrayLenght;

    private void Awake()
    {
        cam = Camera.main;
        volume = cam.GetComponent<PostProcessVolume>();
        volume.profile.TryGetSettings(out TestSettings);
        registeredPoints = new Vector4[TestSettings.ArrayLenght];
    }

    private void Update()
    {
        if (Input.GetMouseButtonDown(0) && currentPointIndex < registeredPoints.Length - 1)
        {
            mouseClickPos = cam.ScreenToViewportPoint(Input.mousePosition);
            registeredPoints[currentPointIndex] = mouseClickPos;
            currentPointIndex++;
        }
    }
}