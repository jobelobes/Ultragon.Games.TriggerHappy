using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;

namespace TriggerHappy.GameObjects
{
    public class Level : Microsoft.Xna.Framework.DrawableGameComponent
    {
        #region Static Variables
        private static readonly Int32 TILE_SIZE = 32;
        #endregion

        #region Variables
        private Microsoft.Xna.Framework.Vector2 _offset;
        private Microsoft.Xna.Framework.Vector2 _size;

        private Microsoft.Xna.Framework.Graphics.Texture2D _tileSet;

        private Microsoft.Xna.Framework.Graphics.SpriteBatch _spritebatch;
        #endregion

        #region Properties
        public Vector2 Position { get { return this._offset; } }
        public Vector2 Size { get { return this._size; } }
        #endregion

        #region Constructors and Finalizers
        public Level(Game game, Vector2 levelSize)
            : base(game)
        {
            this._offset = Vector2.Zero;
            this._size = levelSize * Level.TILE_SIZE;
        }
        #endregion

        #region Methods
        public void CenterOn(Vector2 position)
        {
            Viewport viewport = this.Game.GraphicsDevice.Viewport;
            this._offset = position - new Vector2(viewport.Width, viewport.Height) / 2;
            this._offset.X = Math.Min(Math.Max(0, this._offset.X), this._size.X - viewport.Width);
            this._offset.Y = Math.Min(Math.Max(0, this._offset.Y), this._size.Y - viewport.Height);
        }

        public void Move(Vector2 offset)
        {
            if (offset == Vector2.Zero)
                return;

            Viewport viewport = this.Game.GraphicsDevice.Viewport;
            this._offset += offset;
            this._offset.X = Math.Min(Math.Max(0, this._offset.X), this._size.X - viewport.Width);
            this._offset.Y = Math.Min(Math.Max(0, this._offset.Y), this._size.Y - viewport.Height);
        }

        private Rectangle GetTile(int x, int y)
        {
            //return new Rectangle(0, 5 * Level.TILE_SIZE, Level.TILE_SIZE, Level.TILE_SIZE);
            return new Rectangle(0, 0, Level.TILE_SIZE, Level.TILE_SIZE);
        }
        #endregion

        #region Overriden Methods
        public override void Initialize()
        {
            base.Initialize();

            this._spritebatch = new SpriteBatch(this.Game.GraphicsDevice);
        }
        protected override void LoadContent()
        {
            base.LoadContent();

            this._tileSet = this.Game.Content.Load<Texture2D>("FloorTile");
        }
        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);
        }

        public override void Draw(GameTime gameTime)
        {
            base.Draw(gameTime);

            Viewport viewport = this.Game.GraphicsDevice.Viewport;
            Vector2 drawOffset = new Vector2(this._offset.X % Level.TILE_SIZE, this._offset.Y % Level.TILE_SIZE) * -1.0f;

            int xOffset = Convert.ToInt32(Math.Floor((this._offset.X * -1.0f) / Level.TILE_SIZE));
            int yOffset = Convert.ToInt32(Math.Floor((this._offset.Y * -1.0f) / Level.TILE_SIZE));

            int xSize = Convert.ToInt32(Math.Ceiling((float)viewport.Width / Level.TILE_SIZE)) + 1;
            int ySize = Convert.ToInt32(Math.Ceiling((float)viewport.Height / Level.TILE_SIZE)) + 1;

            this._spritebatch.Begin();
            for (int x = 0; x < xSize; x++)
            {
                for (int y = 0; y < ySize; y++)
                {
                    this._spritebatch.Draw(this._tileSet,
                        new Rectangle(Convert.ToInt32(x * Level.TILE_SIZE + drawOffset.X), Convert.ToInt32(y * Level.TILE_SIZE + drawOffset.Y), Level.TILE_SIZE, Level.TILE_SIZE),
                        this.GetTile(xOffset + x, yOffset + y),
                        Color.White);
                }
            }
            this._spritebatch.End();
        }
        #endregion
    }
}
