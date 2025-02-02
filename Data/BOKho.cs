﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Data
{
    public class BOKho
    {
        KaraokeEntities mKaraokeEntities = null;
        public BOKho(Data.Transit transit)
        {
            mKaraokeEntities = new KaraokeEntities();
        }
        

        public IQueryable<KHO> GetAll()
        {
            return mKaraokeEntities.KHOes.Where(s => s.Deleted == false);
        }
        public static IQueryable<KHO> GetAllNoTracking(Transit mTransit)
        {
            return FrameworkRepository<KHO>.QueryNoTracking(mTransit.KaraokeEntities.KHOes).Where(s => s.Deleted == false);
        }
        public static IQueryable<KHO> GetAll(KaraokeEntities kara)
        {
            var query = from a in kara.KHOes where a.Visual==true && a.Deleted==false select a;
            return query;
        }
        public static IQueryable<KHO> GetAll(KaraokeEntities kara, int khoID)
        {
            var query= from a in kara.KHOes where a.KhoID != khoID select a;
            return query;
        }
        public void Luu(List<KHO> lsArray)
        {
            foreach (KHO item in lsArray)
            {
                if (item.KhoID == 0)
                {
                    mKaraokeEntities.KHOes.AddObject(item);
                }

            }
            mKaraokeEntities.SaveChanges();
        }
        public void Refresh()
        {
            mKaraokeEntities.Refresh(System.Data.Objects.RefreshMode.StoreWins, mKaraokeEntities.KHOes);
        }
    }
}
