import UnityEngine
import System.Linq.Enumerable

#import System.Collections.Generic

import Cubed

#[RequireComponent(MeshFilter)]
#[RequireComponent(MeshRenderer)]
#[RequireComponent(MeshCollider)]
[ExecuteInEditMode]
class CubedObjectBehaviour(MonoBehaviour): 
  public chunkDimensions as Vector3i #=Vector3i(8,8,8)
  public dimensionsInChunks as Vector3i #= Vector3i(1,1,1)
  public cubeSize = 1f
  public material as Material
  public cubeDefinitions as (CubeDefinition)
  public packedTexture as Texture
  public textureAtlas as (Rect)
  public cubeLegend as CubeLegend
  public cubedObject as CubedObject
  
  def Awake():
    cubedObject.Initialize() if cubedObject
    
  def Generate(allCubes as (Cube, 3)):
    DestroyChildren() # patricide?
    cubeLegend = CubeLegend(TextureAtlas: textureAtlas, CubeDefinitions: cubeDefinitions)
    cubedObject = CubedObject()
    cubedObject.cubeSize = cubeSize
    cubedObject.chunkDimensions = chunkDimensions
    cubedObject.dimensionsInChunks = dimensionsInChunks
    cubedObject.cubeMaterial = material
    cubedObject.cubeLegend = cubeLegend
    cubedObject.gameObject = gameObject
    cubedObject.GenerateChunks(dimensionsInChunks, allCubes, transform.position)
  
  def DestroyChildren():
    children = List of GameObject()
    for childTransform as Transform in transform:
      children.Add(childTransform.gameObject)
    for child in children:
      GameObject.DestroyImmediate(child)
  
  def GetChunkAt(position as Vector3):
    return cubedObject.GetChunkAt(position)

  def GetCubeAt(position as Vector3):
    return cubedObject.GetCubeAt(position)
    
  def GetCubeAt(gridPosition as Vector3i):
    return cubedObject.GetCubeAt(gridPosition)

  def RemoveCubeAt(gridPosition as Vector3i):
    cube = cubedObject.Cubes[gridPosition.x, gridPosition.y, gridPosition.z]
    return null if cube == null
    return cube.Chunk.RemoveCube(gridPosition)
  
  def RemoveCubeAt(position as Vector3):
    relativePosition = position - transform.position
    cube = cubedObject.GetCubeAt(relativePosition)
    return null if cube == null
    return cube.Chunk.RemoveCube(cube.Indexes)
  
  def PlaceCubeAt(gridPosition as Vector3i, cube as Cube):
    cubedObject.PlaceCube(gridPosition, cube)
    
  def PlaceCubeAt(worldPosition as Vector3, cube as Cube):
    cubePlacement = GetGridPositionOf(worldPosition - transform.position)
    cubedObject.PlaceCube(cubePlacement, cube)
  
  def PlaceCubeAt(worldPosition as Vector3, cube as GameObject):
    cubePlacement = GetGridPositionOf(worldPosition - transform.position)
    cubedObject.PlaceCube(cubePlacement, cube)
    
  def Generate():
    for chunk in cubedObject.Chunks.Values:
      chunk.Generate(cubedObject.Cubes)
      
  def GetGridPositionOf(worldPosition as Vector3):
    cubePosition = worldPosition / cubeSize
    cubeIndexes = Vector3i(cubePosition)
    return cubeIndexes