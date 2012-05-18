using UnityEngine;
using System.Collections;

public class CubeDefinition : ScriptableObject {
	public int id = 0;
	public string friendlyName = "cube";
	public bool hasCollision = false;
	public Texture2D front;
	public Texture2D back;
	public Texture2D left;
	public Texture2D right;
	public Texture2D top;
	public Texture2D bottom;
	public bool paint = false;
	
	public Texture2D[] Textures { get { return new Texture2D[] { front, back, left, right, top, bottom }; } }
}
